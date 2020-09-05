#!/usr/bin/python
import time
import datetime
import sys
import csv

if len(sys.argv) != 3:
    print('incorect num args. exiting.')
    sys.exit(1)

pkg_temp = '/sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input'
core0_temp = '/sys/devices/platform/coretemp.0/hwmon/hwmon4/temp2_input'
core1_temp = '/sys/devices/platform/coretemp.0/hwmon/hwmon4/temp3_input'
core2_temp = '/sys/devices/platform/coretemp.0/hwmon/hwmon4/temp4_input'
core3_temp = '/sys/devices/platform/coretemp.0/hwmon/hwmon4/temp5_input'
freq_file = '/proc/cpuinfo'

def get_pkg_temp():
    f = open(pkg_temp, 'r')
    line = f.read()
    f.close()
    temp = int(line.strip('\n')) / 1000
    return temp


def get_core0_temp():
    f = open(core0_temp, 'r')
    line = f.read()
    f.close()
    temp = int(line.strip('\n')) / 1000
    return temp


def get_core1_temp():
    f = open(core1_temp, 'r')
    line = f.read()
    f.close()
    temp = int(line.strip('\n')) / 1000
    return temp


def get_core2_temp():
    f = open(core2_temp, 'r')
    line = f.read()
    f.close()
    temp = int(line.strip('\n')) / 1000
    return temp


def get_core3_temp():
    f = open(core3_temp, 'r')
    line = f.read()
    f.close()
    temp = int(line.strip('\n')) / 1000
    return temp


def get_core_freqs():
    f = open(freq_file, 'r')
    contents = f.read()
    f.close()
    freqs = []
    lines = contents.split('\n')
    for n in range(0, len(lines)):
        if lines[n].startswith('cpu MHz'):
            tmp = lines[n].split()
            freqs.append(tmp[-1])
    return freqs


def print_2d(mylist):
    for n in range(0, len(mylist)):
        print(mylist[n])


temps = []
header = ['timestamp', 'pkg_temp', 'core0_temp', 'core1_temp', 'core2_temp', 'core3_temp', 'core0_freq', 'core1_freq', 'core2_freq', 'core3_freq', 'core4_freq', 'core5_freq', 'core6_freq', 'core7_freq']
temps.append(header)

for n in range(0, int(sys.argv[1])):
    dataline = []
    
    tmp1 = []
    tmp1.append(datetime.datetime.now().strftime("%F-%T"))
    tmp1.append(get_pkg_temp())
    tmp1.append(get_core0_temp())
    tmp1.append(get_core1_temp())
    tmp1.append(get_core2_temp())
    tmp1.append(get_core3_temp())

    tmp2 = []
    tmp2 = get_core_freqs()

    dataline = tmp1 + tmp2

    temps.append(dataline)
    time.sleep(1)

print_2d(temps)

#create our output file:
with open(sys.argv[2], 'w', newline='') as f:
    cw = csv.writer(f)
    cw.writerows(temps)
f.close()





