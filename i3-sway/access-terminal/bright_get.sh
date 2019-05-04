#!/bin/sh
#get raw brightness

#raw_bright=$(cat /sys/class/backlight/intel_backlight/brightness)
#bright=$raw_bright
bright=$(brightnessctl get)
max=$(brightnessctl m)

if [ $bright -gt 1 ]; then
    #printf %02d $(($raw_bright / 10))
    #printf %02d $(($bright / 10))
    bright=$(( $bright * 100 ))
    printf %02d $(($bright / $max))
elif [ $bright -le 1 ]; then
    echo "00"
fi

#printf %03d $(cat /sys/class/backlight/intel_backlight/brightness)
