#!/bin/sh

temp0=$(sensors | grep "Core 0" | awk '{printf "%2d", $3}')
temp1=$(sensors | grep "Core 1" | awk '{printf "%2d", $3}')
temp2=$(sensors | grep "Core 2" | awk '{printf "%2d", $3}')
temp3=$(sensors | grep "Core 3" | awk '{printf "%2d", $3}')
temp4=$(sensors | grep "Core 4" | awk '{printf "%2d", $3}')
temp5=$(sensors | grep "Core 5" | awk '{printf "%2d", $3}')

max=0

echo $temp0
echo $temp1
echo $temp2
echo $temp3
echo $temp4
echo $temp5


if $temp0 > $max
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

echo "max: $max"




