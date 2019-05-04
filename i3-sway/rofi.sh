#!/bin/bash

rofi -modi "run,window,files:/home/drake/scripts/i3-sway/rofi_file_browser.sh,ssh" -show run -width 800 -hide-scrollbar -bw 5 -separator-style solid -color-enabled -color-normal "#2b2b2b,#dedede,#373737,#dedede,#2b2b2b" -color-window "#2b2b2b,#dedede,#dedede" -color-active "#7b2c2f,#dedede,#7b2c2f,#dedede,#7b2c2f" -parse-known-hosts
