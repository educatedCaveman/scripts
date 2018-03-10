#!/bin/bash
#unity-settings-daemon &
gnome-settings-daemon &
sleep 3	#might break the script

#xrandr
#xrandr --output DFP9 --rotate left pos 0x0 --output DFP59 pos 1440x200 --primary --output DFP1 --rotate left --pos 5280x0

nitrogen --restore
