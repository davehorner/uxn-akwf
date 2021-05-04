# Uxn-compatible single wave samples

Source: https://www.adventurekid.se/akrt/waveforms/adventure-kid-waveforms/ , released as public domain

Converted with a quick script:

    mkdir -p out
    find AKWF-FREE/AKWF -type f -size 1344c | while read F; do sox "${F}" -c 1 -b 8 -e unsigned-integer out.raw speed 2.34 gain -2 && mv out.raw "out/$(basename "${F%.wav}").pcm" || break; done

