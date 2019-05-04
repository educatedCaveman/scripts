#!/bin/bash

TEMP_FILE=$(mktemp --suffix '.png')
RES=$(xdpyinfo | grep "dimensions" | awk '{print $2}')
#couldn't get this to work yet
#DPMS_VAL="$(xset q | grep "Standby:" | awk '{print $2, $4, $6}')"
#TIMEOUT=60

clean_up() {
    rm -f "$TEMP_FILE"
    xset dpms 0 0 0 #not the best way to revert...
    #xset dpms $DPMS_VAL #not the best way to revert...
}

trap clean_up SIGHUP SIGINT SIGTERM

ffmpeg -loglevel quiet -y -s "$RES" -f x11grab -i "${DISPLAY}" -vframes 1 -vf "gblur=sigma=100" "$TEMP_FILE"
#xset +dpms dpms "$TIMEOUT"  "$TIMEOUT"  "$TIMEOUT" 
xset +dpms dpms 10 10 10 
#i3lock -I "$TIMEOUT" -nei "$TEMP_FILE"
#i3lock -I 60 -nei "$TEMP_FILE"
i3lock -nei "$TEMP_FILE"
clean_up
