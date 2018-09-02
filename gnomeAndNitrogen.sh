#!/bin/bash
#unity-settings-daemon &
#gnome-settings-daemon &
gnome-session 
#sleep 3	#might break the script

#xrandr
#xrandr --output DisplayPort-5 --rotate left --pos 0x0 --output DisplayPort-3 --pos 1440x0 --primary --output DisplayPort-4 --rotate right --pos 5280x0

sleep 1

nitrogen --restore
