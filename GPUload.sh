aticonfig --odgc | grep "GPU load" | awk '{printf "%02d", $4}'
