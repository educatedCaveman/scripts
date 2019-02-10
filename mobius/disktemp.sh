#!/bin/bash

for i in $(sysctl -n kern.disks)
do
DevTemp=`smartctl -a /dev/$i | awk '/Temperature_Celsius/{print $0}' | awk '{print $10 "C"}'`
DevSerNum=`smartctl -a /dev/$i | awk '/Serial Number:/{print $0}' | awk '{print $3}'`
DevName=`smartctl -a /dev/$i | awk '/Device Model:/{print $0}' | awk '{print $3}'`
echo -e $i '\t' $DevTemp '\t' $DevSerNum '\t' $DevName
done
