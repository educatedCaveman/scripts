#!/bin/bash
#restart Transmission
osascript -e 'quit app "Transmission"' && 
sleep 10 &&
open -a "Transmission"
