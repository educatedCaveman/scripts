#!/bin/bash
#set the fn speed of mobius to 20%
ipmitool -I lanplus -H mobius.mgmt -U idrac_remote -P password raw 0x30 0x30 0x01 0x00              
ipmitool -I lanplus -H mobius.mgmt -U idrac_remote -P password raw 0x30 0x30 0x02 0xff 0x14
