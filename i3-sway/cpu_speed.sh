#!/bin/sh

raw_speed=$(grep "cpu MHz" /proc/cpuinfo | awk '{sum += $4; n++ } END { print sum / n }')
trunc_speed=$(printf '%04.*f\n' 0 $raw_speed)
echo "$trunc_speed MHz"
#if [ $trunc_speed -ge 1000 ]; then
#    speed=$(($trunc_speed / 1000))
#    echo "$speed GHz"
#else
#    echo "$raw_speed MHz"
#fi
