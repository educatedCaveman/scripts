#!/bin/sh

temp0=$(sensors | grep "Core 0" |awk '{printf "%2d", $3}')
temp1=$(sensors | grep "Core 1" |awk '{printf "%2d", $3}')
temp2=$(sensors | grep "Core 2" |awk '{printf "%2d", $3}')
temp3=$(sensors | grep "Core 3" |awk '{printf "%2d", $3}')
temp4=$(sensors | grep "Core 4" |awk '{printf "%2d", $3}')
temp5=$(sensors | grep "Core 5" |awk '{printf "%2d", $3}')

tempAvg=$((($temp0+$temp1+$temp2+$temp3+$temp4+$temp5)/6))

echo $tempAvg
