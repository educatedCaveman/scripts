#!/bin/bash
i3-msg floating enable
i3-msg border normal 5
xdotool getactivewindow windowsize 1200 700
xdotool getactivewindow windowmove 5400 1740
#sleep 1
i3-msg sticky enable
i3-msg move scratchpad
