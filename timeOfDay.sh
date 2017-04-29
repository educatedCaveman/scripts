#!/bin/bash
#calculate if it is daytime or nighttime

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/home/drake/scripts:/home/drake
export DSIPLAY=:0.0

lightTheme='Arc-Grey-Darker'
darkTheme='Arc-Grey-Dark'
currTheme=$(/usr/bin/gsettings get org.gnome.desktop.interface gtk-theme)

currentTime=$(date +%H:%M)
sunrise=$(/usr/bin/solunar -l 39.4,-76.8 | grep Sunrise | awk '{print $2}')
sunset=$(/usr/bin/solunar -l 39.4,-76.8 | grep Sunset | awk '{print $2}')

IFS=':' read -a timeArray <<< "$currentTime"
IFS=':' read -a riseArray <<< "$sunrise"
IFS=':' read -a setArray <<< "$sunset"

ct=${timeArray[0]}${timeArray[1]}
rise=${riseArray[0]}${riseArray[1]}
sset=${setArray[0]}${setArray[1]}

declare -i ct
declare -i rise
declare -i sset

#set dark theme, if its not already set
function dark {
    echo "use the dark theme"
    #currTheme=$(/usr/bin/gsettings get org.gnome.desktop.interface gtk-theme)
    currTheme="${currTheme//\'}"
    #darkTheme="Windows 10 Dark"
    echo "current theme is:  $currTheme"
    if [[ "$currTheme" != "$darkTheme" ]];
    then
        #set dark theme
        echo "setting dark theme..."
        /usr/bin/gsettings set org.gnome.desktop.interface gtk-theme "$darkTheme"
    else
        echo "dark theme already set"
    fi
}

#set dark theme, if its not already set
function light {
    echo "use the light theme"
    #currTheme=$(/usr/bin/gsettings get org.gnome.desktop.interface gtk-theme)
    currTheme="${currTheme//\'}"
    #lightTheme="Windows 10 Light"
    echo "current theme is:  $currTheme"
    if [[ "$currTheme" != "$lightTheme" ]];
    then
        #set light theme
        echo "setting light theme..."
        /usr/bin/gsettings set org.gnome.desktop.interface gtk-theme "$lightTheme"
    else
        echo "light theme already set"
    fi
}

#less than sunrise
if [ $ct -lt $rise ];
then
    echo "it is before sunrise"
    dark
elif [ $ct -ge $rise ];
then
    if [ $ct -le $sset ];
    then
        echo "it is daytime"
        light
    elif [ $ct -gt $sset ];
    then
        echo "it is after sunset"
        dark
    else
        echo "something is wrong2, this shouldn't be possible"
    fi
else
    echo "something is wrong, this shouldn't be possible"
fi
