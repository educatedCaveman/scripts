#!/bin/bash

#set color profiles
sleep 1
/usr/bin/colormgr device-make-profile-default /org/freedesktop/ColorManager/devices/xrandr_DELL_P4317Q_J0DKG69J0ZJL_drake_1000 icc-86872c7ea0213117958a19dee06858d7
sleep 1
/usr/bin/colormgr device-make-profile-default /org/freedesktop/ColorManager/devices/xrandr_DELL_U2715H_H7YCC57203RS_drake_1000 icc-5a56a688e6ac1b8a9f82df701891b660
sleep 1
/usr/bin/colormgr device-make-profile-default /org/freedesktop/ColorManager/devices/xrandr_ASUS_PB278_E9LMTF132739_drake_1000 icc-277c06c0a0215baef6ef4b76f50924b2

#start redshift
sleep 1
gtk-redshift -l 39.4:-76.8 -t 6500:4000 -m randr:preserve=1 2>/dev/null &
