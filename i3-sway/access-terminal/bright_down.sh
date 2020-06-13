#!/bin/bash
#decredse brightness
brightness=$(brightnessctl get)

#if brightness at or below max:
if [ "$brightness" -le 120000 ]; then
    #if brightness >10%, decrease by 5%
    if [ "$brightness" -gt 12000 ]; then
        brightnessctl -q set 5%-
    #if brighness <= 10%...
    elif [ "$brightness" -le 12000 ]; then
        #if brightness is 1, then set to 0
        if [ "$brightness" -eq 1 ]; then
            brightnessctl -q set 0
        #if brightness <= 1%, set to 1
        elif [ "$brightness" -le 1200 ]; then
            brightnessctl -q set 1
        #otherwise, decrease by 1%
        else
            echo "TEST"
            brightnessctl -q set 1%-
        fi
    fi
fi
