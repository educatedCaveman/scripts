#!/bin/bash
#set up terminals

delay=1  #500ms is about as low as I can get it...

#scratchpad
swaymsg 'workspace "0: X "; exec /usr/bin/terminator'
sleep $delay    #seems to be needed to wait for terminator to finish launching
swaymsg floating enable
swaymsg border normal 5
swaymsg resize set width 1200 px height 690 px
swaymsg move absolute position 5400 1740
swaymsg sticky enable
swaymsg move scratchpad
sleep $delay

#monitoring terminals
swaymsg 'workspace "0: Monitoring "'
swaymsg 'exec /usr/bin/terminator -p htop'
swaymsg splitv  #goes after first terminal to preserve ordering
swaymsg 'exec /usr/bin/terminator -p speedometer-up'
swaymsg 'exec /usr/bin/terminator -p speedometer-down'
#sleep 2   #needed to allow terminators to launch

