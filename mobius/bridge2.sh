#!/bin/bash
#freenas networking interfaces
LAGG="lagg2"
BRIDGE="bridge2"
    
while :; do
    #check for interface
        #if exists, break
    if [ "$(/sbin/ifconfig | /usr/bin/grep ^${LAGG}:)" ];
    then
        break
    fi
done

sleep 2
/sbin/ifconfig "${LAGG}" up
/sbin/ifconfig "${BRIDGE}" destroy
/sbin/ifconfig "${BRIDGE}" create
/sbin/ifconfig "${BRIDGE}" addm "${LAGG}" up
exit 0

