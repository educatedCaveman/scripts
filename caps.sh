#!/bin/bash
#tell if caps lock is on or off:
caps=$(xset q | grep "Caps Lock" | awk '{print $4}')
#echo $caps
if [ $caps == "off" ]
then
    #echo "OFF"
    echo "0"
else
    #echo "ON!"
    echo "1"
fi
