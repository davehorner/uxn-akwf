#!/usr/bin/env bash
set -u
set -o pipefail

# Convert uxn-akwf layout to SuperDirt banks:
#  - Each TOP-LEVEL directory -> dirt/akwf_<dirname>/*.wav
#  - Top-level loose *.pcm -> dirt/akwf_loose/*.wav
#  - Input .pcm are 8-bit unsigned mono (AKWF single-cycle 256 samples)
#  - Output .wav are 16-bit mono at 44.1kHz (SuperDirt-friendly)
#
# Usage:
#   chmod +x akwf_to_dirt.sh
#   ./akwf_to_dirt.sh
#
# Options:
#   STRICT_NAMES=1   # fail instead of sanitizing illegal Windows names

OUTPUT_ROOT="dirt"
STRICT_NAMES="${STRICT_NAMES:-0}"   # 0=sanitize, 1=error on illegal names

command -v sox >/dev/null 2>&1 || {
  echo "Error: sox not installed. Try: sudo apt install sox" >&2
  exit 1
}

mkdir -p "$OUTPUT_ROOT"
LOG_ERR="$OUTPUT_ROOT/convert_errors.log"
MAP_LOG="$OUTPUT_ROOT/name_map.tsv"
: >"$LOG_ERR"
: >"$MAP_LOG"

# Windows filename sanity helpers (you’re on NTFS under /mnt/c)
is_windows_reserved_basename() {
  local b="$1"
  shopt -s nocasematch
  if [[ "$b" =~ ^(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])(\..*)?$ ]]; then
    shopt -u nocasematch
    return 0
  fi
  shopt -u nocasematch
  return 1
}
has_windows_illegal_chars() {
  [[ "$1" =~ [\<\>\:\"\/\\\|\?\*] ]]
}
sanitize_basename() {
  local in="$1"
  local out="${in//[<>:\"/\\|?*]/_}"
  if is_windows_reserved_basename "$out"; then
    out="_$out"
  fi
  printf "%s" "$out"
}

convert_dir_bank() {
  # Convert all *.pcm directly inside a top-level folder
  local src_dir="$1"
  local bank_name
  bank_name="$(basename "$src_dir")"
  local out_dir="$OUTPUT_ROOT/akwf_${bank_name}"
  mkdir -p "$out_dir"

  echo "Converting folder → $out_dir"

  local total=0 ok=0 fail=0
  # Only files at maxdepth 1 (top-level contents of that folder)
  while IFS= read -r -d '' src; do
    ((total++))
    local base stem out_base dst
    base="$(basename "$src")"
    stem="${base%.*}"
    out_base="${stem}.wav"

    if has_windows_illegal_chars "$out_base" || is_windows_reserved_basename "$out_base"; then
      if [[ "$STRICT_NAMES" == "1" ]]; then
        echo "  fail  $base (illegal name; STRICT_NAMES=1)" | tee -a "$LOG_ERR" >/dev/null
        ((fail++))
        continue
      else
        local safe
        safe="$(sanitize_basename "$out_base")"
        if [[ "$safe" != "$out_base" ]]; then
          printf "%s\t%s\n" "$out_base" "$safe" >>"$MAP_LOG"
          out_base="$safe"
        fi
      fi
    fi

    dst="$out_dir/$out_base"

    # AKWF are 8-bit unsigned mono raw (single-cycle); render as WAV 44.1k S16
    if sox -t raw -r 44100 -c 1 -e unsigned -b 8 "$src" \
            -t wav -r 44100 -c 1 -e signed -b 16 "$dst" \
            gain -n -1 dither -s 2>>"$LOG_ERR"; then
      printf "   ok   %s\n" "$out_base"
      ((ok++))
    else
      echo "  fail  $base (see $LOG_ERR)" >&2
      ((fail++))
    fi
  done < <(find "$src_dir" -maxdepth 1 -type f -iname '*.pcm' -print0 | sort -z)

  echo "  summary: $ok ok, $fail failed (total $total)"
}

convert_loose_files() {
  # Convert top-level *.pcm into dirt/akwf_loose
  local out_dir="$OUTPUT_ROOT/akwf_loose"
  mkdir -p "$out_dir"
  echo "Converting top-level loose files → $out_dir"

  local total=0 ok=0 fail=0
  while IFS= read -r -d '' src; do
    ((total++))
    local base stem out_base dst
    base="$(basename "$src")"
    stem="${base%.*}"
    out_base="${stem}.wav"

    if has_windows_illegal_chars "$out_base" || is_windows_reserved_basename "$out_base"; then
      if [[ "$STRICT_NAMES" == "1" ]]; then
        echo "  fail  $base (illegal name; STRICT_NAMES=1)" | tee -a "$LOG_ERR" >/dev/null
        ((fail++))
        continue
      else
        local safe
        safe="$(sanitize_basename "$out_base")"
        if [[ "$safe" != "$out_base" ]]; then
          printf "%s\t%s\n" "$out_base" "$safe" >>"$MAP_LOG"
          out_base="$safe"
        fi
      fi
    fi

    dst="$out_dir/$out_base"

    if sox -t raw -r 44100 -c 1 -e unsigned -b 8 "$src" \
            -t wav -r 44100 -c 1 -e signed -b 16 "$dst" \
            gain -n -1 dither -s 2>>"$LOG_ERR"; then
      printf "   ok   %s\n" "$out_base"
      ((ok++))
    else
      echo "  fail  $base (see $LOG_ERR)" >&2
      ((fail++))
    fi
  done < <(find . -maxdepth 1 -type f -iname '*.pcm' -print0 | sort -z)

  echo "  summary: $ok ok, $fail failed (total $total)"
}

# 1) loose files in repo root
convert_loose_files

# 2) every top-level directory becomes a bank dir (skip .git and the dirt we’re creating)
while IFS= read -r -d '' d; do
  case "$(basename "$d")" in
    .git|"$OUTPUT_ROOT") continue ;;
  esac
  convert_dir_bank "$d"
done < <(find . -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

echo "✅ Done. Banks in $OUTPUT_ROOT/akwf_*"
[[ -s "$LOG_ERR" ]] && echo "⚠️  Errors logged to $LOG_ERR"
[[ -s "$MAP_LOG" ]] && echo "ℹ️  Sanitized names logged to $MAP_LOG"

