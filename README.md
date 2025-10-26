# AKWF → SuperDirt Sample Bank

This repository contains **SuperDirt-ready WAV conversions** of AKWF/uxn waveforms.

## Bank summary

| Bank | Files | Size |
|---|---:|---:|
| `akwf_AKWF` | 2011 | 1.1 MiB |
| `akwf_R_asym` | 26 | 14.1 KiB |
| `akwf_R_sym` | 26 | 14.1 KiB |
| `akwf_aguitar` | 38 | 20.6 KiB |
| `akwf_altosax` | 26 | 14.1 KiB |
| `akwf_birds` | 14 | 7.6 KiB |
| `akwf_bitreduced` | 40 | 21.7 KiB |
| `akwf_blended` | 73 | 39.6 KiB |
| `akwf_bsaw` | 10 | 5.4 KiB |
| `akwf_c604` | 32 | 17.4 KiB |
| `akwf_cello` | 19 | 10.3 KiB |
| `akwf_cheeze` | 6 | 3.3 KiB |
| `akwf_clarinett` | 25 | 13.6 KiB |
| `akwf_clavinet` | 33 | 17.9 KiB |
| `akwf_dbass` | 69 | 37.5 KiB |
| `akwf_distorted` | 45 | 24.4 KiB |
| `akwf_ebass` | 70 | 38.0 KiB |
| `akwf_eguitar` | 22 | 11.9 KiB |
| `akwf_eorgan` | 154 | 83.6 KiB |
| `akwf_epiano` | 73 | 39.6 KiB |
| `akwf_flute` | 17 | 9.2 KiB |
| `akwf_fmsynth` | 122 | 66.2 KiB |
| `akwf_gapsaw` | 42 | 22.8 KiB |
| `akwf_granular` | 44 | 23.9 KiB |
| `akwf_hdrawn` | 50 | 27.1 KiB |
| `akwf_hvoice` | 104 | 56.5 KiB |
| `akwf_linear` | 85 | 46.2 KiB |
| `akwf_loose` | 32 | 17.4 KiB |
| `akwf_oboe` | 13 | 7.1 KiB |
| `akwf_oscchip` | 158 | 85.8 KiB |
| `akwf_overtone` | 44 | 23.9 KiB |
| `akwf_piano` | 30 | 16.3 KiB |
| `akwf_pluckalgo` | 9 | 4.9 KiB |
| `akwf_rAsymSqu` | 26 | 14.1 KiB |
| `akwf_rSymSqu` | 26 | 14.1 KiB |
| `akwf_raw` | 36 | 19.5 KiB |
| `akwf_saw` | 50 | 27.1 KiB |
| `akwf_sin` | 12 | 6.5 KiB |
| `akwf_sinharm` | 16 | 8.7 KiB |
| `akwf_snippet` | 47 | 25.5 KiB |
| `akwf_squ` | 100 | 54.3 KiB |
| `akwf_stereo` | 3 | 1.6 KiB |
| `akwf_symetric` | 17 | 9.2 KiB |
| `akwf_tannerin` | 4 | 2.2 KiB |
| `akwf_theremin` | 22 | 11.9 KiB |
| `akwf_tri` | 25 | 13.6 KiB |
| `akwf_vgame` | 137 | 74.4 KiB |
| `akwf_vgsaw` | 16 | 8.7 KiB |
| `akwf_vgsin` | 16 | 8.7 KiB |
| `akwf_vgsqu` | 16 | 8.7 KiB |
| `akwf_vgtri` | 16 | 8.7 KiB |
| `akwf_violin` | 14 | 7.6 KiB |

## Format
- 16‑bit signed **mono** WAV
- 44.1 kHz sample rate
- Filenames preserved from source `.pcm` (extension changed to `.wav`)

## Reproducibility
Converted with scripts in this repo (Bash + SoX). On Debian/Ubuntu:

```bash
sudo apt update && sudo apt install -y sox
```

it is 2.20 MB on disk.

See https://github.com/davehorner/uxn-st/tree/dirt for the instructions to pull.
