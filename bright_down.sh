#!/bin/bash
#decredse brightness

#brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
brightness=$(brightnessctl get)

if [ "$brightness" -gt 900 ]; then
    #set brightness = 900
    let brightness=900
elif [ "$brightness" -le 900 ]; then
    if [ "$brightness" -gt 100 ]; then
        #if brightness <= 900, and > 100, -50
        let brightness=$brightness-50
    elif [ "$brightness" -le 100 ]; then
        if [ "$brightness" -eq 1 ]; then
            let brightness=0
        elif [ "$brightness" -le 20 ]; then
            let brightness=1
        else
            let brightness=$brightness-20
        fi
    fi
fi

#echo "echo $brightness > /sys/class/backlight/intel_backlight/brightness" | sudo bash
#echo "new brightness: $brightness"
brightnessctl set "${brightness}"
