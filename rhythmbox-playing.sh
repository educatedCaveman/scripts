#!/bin/sh

not_playing=" - "
status=$(rhythmbox-client --print-playing)

if [ "$status" != "$not_playing" ]; 
then 
    rhythmbox-client --print-playing-format="%tt -- (%ta - %at)"
else
    echo ""
fi
