#!/bin/sh
#scripts to benchmark the CPU.  temps and freqencies.
#variables:
DATE=$(date +%F-%T)
TEMP=/tmp/stress_temp_$DATE.txt
FREQ=/tmp/stress_freq_$DATE.txt
OUTFILE=$HOME/cpu_benchmark_$DATE.csv

#the actual stress test
stress -c $(nproc) &
#stress -c 1 &  #for testing

python $HOME/scripts/cpu_data.py 300 $OUTFILE

pkill stress
