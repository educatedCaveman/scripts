#!/bin/bash
#set up terminals

delay=1  #500ms is about as low as I can get it...

#scratchpad
swaymsg 'workspace "0: X "; exec /usr/bin/gedit'
sleep $delay    #seems to be needed to wait for gedit to finish launching
# swaymsg floating enable
# swaymsg border normal 5
# swaymsg resize set width 1200 px height 690 px
# swaymsg move absolute position 5400 1740
# swaymsg sticky enable
swaymsg move scratchpad
sleep $delay
