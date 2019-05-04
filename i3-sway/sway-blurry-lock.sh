#!/bin/bash
#wrapper for swaylock

#variables:
outputs=$(swaymsg -t get_outputs | grep name | awk '{print $2}' | cut -d'"' -f 2)
outdir="/tmp/"
#outlist=''
outlist=()
cnt=0
tmpconf="/tmp/swaylock.conf"
tmpPics=()
timeout=60
arg=""

if [[ $# -ge 1 ]];
then
    arg="${1}"
fi

#create an array of inputs:
while IFS='\n' read -r line; do
    outlist[cnt]="$line"
    cnt=$(( $cnt + 1 ))
done <<< "${outputs}"

#take screenshots, blur, create tmp config file for swaylock
for output in "${outlist[@]}"; do
    infile="${outdir}${output}.png"
    outfile="${outdir}${output}.blur.png"
    rm "${infile}" 2>/dev/null
    rm "${outfile}" 2>/dev/null
    grim -o "${output}" "${infile}"
    ffmpeg -loglevel quiet -y -i "${infile}" -vframes 1 -vf "gblur=sigma=100" "${outfile}"
    tmpPics+=("${infile}")
    tmpPics+=("${outfile}")
    printf "image=${output}:${outfile}\n" >> ${tmpconf}
done

#run swaylock, cleaning up after
#swayidle timeout "${timeout}" 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' &

#check for hibernate arg:
if [[ "${arg}" == "hibernate" ]];
then
    #echo "we should hibernate"
    #swaylock in bg, save PID, hibernate, wait for swaylock to be complete
    #swayidle timeout "${timeout}" 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' &
    swaylock -C "$tmpconf" &
    PID=$!    
    sleep 5     #wait just a bit for swaylock
    swaymsg "output * dpms off"
    sudo pm-hibernate
    swaymsg "output * dpms on"
    wait $PID
elif [[ "${arg}" == "idle" ]];
then
    #echo "just lock, no dpms"
    swaylock -C "$tmpconf"
else
    #echo "we should just lock"
    #just swaylock
    swayidle timeout "${timeout}" 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' &
    swaylock -C "$tmpconf"
    pkill -n swayidle
fi

#clean up:
#pkill -n swayidle
rm "$tmpconf" 
for file in "${tmpPics[@]}"; do
    rm "${file}"
done

