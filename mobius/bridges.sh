#!/bin/bash
#freenas networking interfaces
LAGG0="lagg0"
LAGG1="lagg1"
LAGG2="lagg2"
BRIDGE0="bridge0"
BRIDGE1="bridge1"
BRIDGE2="bridge2"

timeout=10

#wait for lagg0 to be up:
cntr=0
while :; do
    if [ "$(/sbin/ifconfig | /usr/bin/grep ^${LAGG0}:)" ];
    then
        break
    fi
    ((cntr++))
    if [ $cntr -ge $timeout ];
    then
        exit 1
    else
        sleep 1
    fi
done

#wait for lagg1 to be up:
while :; do
    if [ "$(/sbin/ifconfig | /usr/bin/grep ^${LAGG1}:)" ];
    then
        break
    fi
    ((cntr++))
    if [ $cntr -ge $timeout ];
    then
        exit 1
    else
        sleep 1
    fi
done

#wait for lagg2 to be up
while :; do
    if [ "$(/sbin/ifconfig | /usr/bin/grep ^${LAGG2}:)" ];
    then
        break
    fi
    ((cntr++))
    if [ $cntr -ge $timeout ];
    then
        exit 1
    else
        sleep 1
    fi
done

#until /sbin/ifconfig | /usr/bin/grep -q "^${LAGG}:"; do sleep 1; done
sleep 1
#destroy the bridges to undo what is done by default:
if [ "$(/sbin/ifconfig | /usr/bin/grep ^${BRIDGE0}:)" ];
then
    /sbin/ifconfig "${BRIDGE0}" destroy
fi
if [ "$(/sbin/ifconfig | /usr/bin/grep ^${BRIDGE1}:)" ];
then   
    /sbin/ifconfig "${BRIDGE1}" destroy
fi
if [ "$(/sbin/ifconfig | /usr/bin/grep ^${BRIDGE2}:)" ];
then
    /sbin/ifconfig "${BRIDGE2}" destroy
fi
#exit if the bridges still exist:
if [ "$(/sbin/ifconfig | /usr/bin/grep ^${BRIDGE0}:)" ];
then
    exit 1
fi
if [ "$(/sbin/ifconfig | /usr/bin/grep ^${BRIDGE1}:)" ];
then
    exit 1
fi
if [ "$(/sbin/ifconfig | /usr/bin/grep ^${BRIDGE2}:)" ];
then
    exit 1
fi

#/sbin/ifconfig "${BRIDGE0}" destroy
#/sbin/ifconfig "${BRIDGE1}" destroy
#/sbin/ifconfig "${BRIDGE2}" destroy
#recreate them:
/sbin/ifconfig "${BRIDGE0}" create
if [ $? -ne 0 ];
then
    exit 1
fi
/sbin/ifconfig "${BRIDGE1}" create
if [ $? -ne 0 ];
then
    exit 1
fi
/sbin/ifconfig "${BRIDGE2}" create
if [ $? -ne 0 ];
then
    exit 1
fi
#and add the laggs to them
/sbin/ifconfig "${BRIDGE0}" addm "${LAGG0}" up
if [ $? -ne 0 ];
then
    exit 1
fi
/sbin/ifconfig "${BRIDGE1}" addm "${LAGG1}" up
if [ $? -ne 0 ];
then
    exit 1
fi
/sbin/ifconfig "${BRIDGE2}" addm "${LAGG2}" up
if [ $? -ne 0 ];
then
    exit 1
fi
exit 0

