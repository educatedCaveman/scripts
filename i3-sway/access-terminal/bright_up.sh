#!/bin/bash
#increase brightness
brightness=$(brightnessctl get)

#if 0, set to 1
if [ "$brightness" -le 0 ]; then
    brightnessctl -q set 1

#if brightness >1...
elif [ "$brightness" -ge 1 ]; then

    #if brightness <10%, incriment by 1%
    if [ "$brightness" -lt 12000 ]; then
        brightnessctl -q set +1%

    #if brightness >10%, incriment by 5% until max    
    elif [ "$brightness" -ge 12000 ]; then
        if [ "$brightness" -lt 120000 ]; then
            brightnessctl -q set +5%
        elif [ "$brightness" -ge 120000 ]; then
            brightnessctl -q set 100%
        fi
    fi
fi
