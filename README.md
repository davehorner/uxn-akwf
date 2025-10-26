# Uxn-compatible single wave samples

Source: https://www.adventurekid.se/akrt/waveforms/adventure-kid-waveforms/ , released as public domain

Converted with a quick script:

    mkdir -p out
    find AKWF-FREE/AKWF -type f -size 1344c | while read F; do sox "${F}" -c 1 -b 8 -e unsigned-integer out.raw speed 2.34 gain -2 && mv out.raw "out/$(basename "${F%.wav}").pcm" || break; done

## 🎧 uxn-akwf — Dirt Branch

This repository contains **SuperDirt-ready WAV conversions** of AKWF/uxn waveforms.
This branch (`dirt`) contains WAV-converted versions of the raw sound files from the main branch.

It’s meant for easy use with SuperDirt in TidalCycles.


The files are about **2.20 MB** on disk.


---

### 🔽 Download or Clone

If you only want the converted WAV files (and not the entire repo history), use:

```bash
# clone just the dirt branch
git clone --branch dirt --single-branch --depth 1 https://github.com/davehorner/uxn-akwf.git
cd uxn-akwf
```

Or simply download the ZIP:


👉 **[Download WAVs (dirt branch)](https://github.com/davehorner/uxn-akwf/archive/refs/heads/dirt.zip)**
