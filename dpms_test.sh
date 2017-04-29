#!/bin/sh

vals=$(xset q | grep "Standby:" | awk '{print $2, $4, $6}')

echo $vals
xset dpms 0 0 0
xset dpms $vals
