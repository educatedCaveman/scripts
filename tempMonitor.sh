#!/bin/bash

trap control_c SIGINT

control_c()
{
    echo -en "\nmax temp was: $max\n"
    exit 0
}

max='0'

max_temp()
{
    if [[ "$temp0" > "$max" ]]
    then
        max=$temp0
    fi
    if (($temp1 > $max))
    then
        max=$temp1
    fi
    if (($temp2 > $max))
    then
        max=$temp2
    fi
    if (($temp3 > $max))
    then
        max=$temp3
    fi
    if (($temp4 > $max))
    then
        max=$temp4
    fi
    if (($temp5 > $max))
    then
        max=$temp5
    fi
}

while true
do
#    temp0=$(sensors | grep "Core 0" | awk '{printf "%2d", $3}')
#    temp1=$(sensors | grep "Core 1" | awk '{printf "%2d", $3}')
#    temp2=$(sensors | grep "Core 2" | awk '{printf "%2d", $3}')
#    temp3=$(sensors | grep "Core 3" | awk '{printf "%2d", $3}')
#    temp4=$(sensors | grep "Core 4" | awk '{printf "%2d", $3}')
#    temp5=$(sensors | grep "Core 5" | awk '{printf "%2d", $3}')

#    echo "tmep0: $temp0"
#    echo "tmep1: $temp1"
#    echo "tmep2: $temp2"
#    echo "tmep3: $temp3"
#    echo "tmep4: $temp4"
#    echo "tmep5: $temp5"

#    avg=$((($temp0+$temp1+temp2+temp3+temp4+temp5)/6))

#   echo "avg: $avg"

    max_temp
done


