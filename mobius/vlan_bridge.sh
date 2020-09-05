#!/bin/bash
#create the desired network layout

#variables:
PARENT=ix1
VLAN_TAGS=(11 12 13)
VLAN_NAMES=(vlan11 vlan12 vlan13)
VLAN_DESCRIPTIONS=(SERVER_VLAN VM_VLAN LAB_VLAN)
BRIDGE_NAMES=(bridge11 bridge12 bridge13)
BRIDGE_DESCRIPTIONS=(SERVER_VLAN_bridge VM_VLAN_bridge LAB_VLAN_bridge)

#set error detection:
set -e

#initial parent interface config
ifconfig $PARENT down
ifconfig $PARENT mtu 9000

#configure the network
for index in ${!VLAN_TAGS[*]}
do
    ifconfig ${VLAN_NAMES[$index]} create vlan ${VLAN_TAGS[$index]} vlandev $PARENT description ${VLAN_DESCRIPTIONS[$index]}
    ifconfig ${BRIDGE_NAMES[$index]} create mtu 9000 description ${BRIDGE_DESCRIPTIONS[$index]}
    ifconfig ${BRIDGE_NAMES[$index]} addm ${VLAN_NAMES[$index]}
done

#bring the interfaces up
ifconfig $PARENT up

for index in ${!VLAN_TAGS[*]}
do
    ifconfig ${VLAN_NAMES[$index]} up
    ifconfig ${BRIDGE_NAMES[$index]} up
done
