#!/bin/bash

# Get available windows
#windows=$(swaymsg -t get_tree | jq -r '.nodes[1].nodes[].nodes[] | .. | (.id|tostring) + " " + .name?' | grep -e "[0-9]* ."  )
windows=$(swaymsg -t get_tree | jq -r 'recurse(.nodes[]?)|recurse(.floating_nodes[]?)|select(.type=="con"),select(.type=="floating_con")|select(.name!=null)|(.id|tostring)+" \t "+.name')

# Select window with rofi
selected=$(echo "$windows" | rofi -dmenu -i -width 800 -hide -scrollbar -bw 5 -separator-style solid -color-enabled -color-normal "#2b2b2b,#dedede,#373737,#dedede,#2b2b2b" -color-window "#2b2b2b,#dedede,#dedede" -color-active "#7b2c2f,#dedede,#7b2c2f,#dedede,#7b2c2f"| awk '{print $1}')

# Tell sway to focus said window
swaymsg [con_id="$selected"] focus
