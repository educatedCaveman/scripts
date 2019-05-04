#!/bin/bash
#wrapper script for launching terminals where I want them:
swaymsg 'workspace "0: Monitoring "'
swaymsg 'exec /usr/bin/terminator -p htop'
swaymsg splitv  #goes after first terminal to preserve ordering
swaymsg 'exec /usr/bin/terminator -p speedometer-up'
swaymsg 'exec /usr/bin/terminator -p speedometer-down'
#sleep 2   #needed to allow terminators to launch
