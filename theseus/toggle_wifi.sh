#!/bin/bash
# https://www.reddit.com/r/kde/comments/120lb1a/why_does_kde_network_manager_connects_to_both_my/
# https://askubuntu.com/questions/1271491/disable-wifi-if-lan-is-connected

export LC_ALL=C

enable_disable_wifi ()
{
    result=$(nmcli dev | grep "ethernet" | grep -w "connected")
    if [ -n "$result" ]; then
        nmcli radio wifi off
    else
        nmcli radio wifi on
    fi
}

if [ "$2" = "up" ]; then
    enable_disable_wifi
fi

if [ "$2" = "down" ]; then
    enable_disable_wifi
fi