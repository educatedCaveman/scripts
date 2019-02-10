#!/bin/bash
#freenas networking interfaces
LAGG0="lagg0"
LAGG1="lagg1"
LAGG2="lagg2"
BRIDGE0="bridge0"
BRIDGE1="bridge1"
BRIDGE2="bridge2"

#wait for lagg0 to be up:
while :; do
    if [ "$(/sbin/ifconfig | /usr/bin/grep ^${LAGG0}:)" ];
    then
        break
    fi
    sleep 1
done

#wait for lagg1 to be up:
while :; do
    if [ "$(/sbin/ifconfig | /usr/bin/grep ^${LAGG1}:)" ];
    then
        break
    fi
    sleep 1
done

#wait for lagg2 to be up
while :; do
    if [ "$(/sbin/ifconfig | /usr/bin/grep ^${LAGG2}:)" ];
    then
        break
    fi
    sleep 1
done

#until /sbin/ifconfig | /usr/bin/grep -q "^${LAGG}:"; do sleep 1; done
sleep 1
#destroy the bridges to undo what is done by default:
/sbin/ifconfig "${BRIDGE0}" destroy
/sbin/ifconfig "${BRIDGE1}" destroy
/sbin/ifconfig "${BRIDGE2}" destroy
#recreate them:
/sbin/ifconfig "${BRIDGE0}" create
/sbin/ifconfig "${BRIDGE1}" create
/sbin/ifconfig "${BRIDGE2}" create
#and add the laggs to them
/sbin/ifconfig "${BRIDGE0}" addm "${LAGG0}" up
/sbin/ifconfig "${BRIDGE1}" addm "${LAGG1}" up
/sbin/ifconfig "${BRIDGE2}" addm "${LAGG2}" up
exit 0

