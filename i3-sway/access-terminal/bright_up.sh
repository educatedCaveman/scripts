#!/bin/bash
#increase brightness

#max_bright=$(cat /sys/class/backlight/intel_backlight/max_brightness)
#brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
max_bright=$(brightnessctl m)
brightness=$(brightnessctl get)

if [ "$brightness" -le 0 ]; then
    #set brightness = 1
    let brightness=1
    #brightnessctl set 1
elif [ "$brightness" -eq 1 ]; then
    #set brightness 20
    let brightness=20
    #brightnessctl set 2%
elif [ "$brightness" -gt 1 ]; then
    if [ "$brightness" -lt 100 ]; then
        #let brightness=$brightness+20
        #correct
        #if brightness < 100, smaller increases
        #1, 20, 40, 60, 80, 100
        let brightness=$brightness+20
        #brightnessctl set +2%
    elif [ "$brightness" -ge 100 ]; then
        if [ "$brightness" -lt 900 ]; then
            #if brightness >=100 and <900, add 50
            let brightness=$brightness+50
            #brightnessctl set +5%
        elif [ "$brightness" -ge 900 ]; then
            #if brightness >= 900, set to 937
            let brightness=937
            #brightnessctl set "${max_bright}"
        fi
    fi
fi

#echo "echo $brightness > /sys/class/backlight/intel_backlight/brightness" | sudo bash
#echo "new brightness: $brightness"
brightnessctl set "${brightness}"
