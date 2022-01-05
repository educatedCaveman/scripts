#!/bin/bash

source $HOME/.zsh_secrets
IPMI_HOST="192.168.1.7"
USER_NAME="idrac_remote"
# PASS=${IDRAC_PW}    # get from .zsh_secrets

echo $IPMI_HOST
echo $USER_NAME
echo $IDRAC_PW

# ipmitool -I lanplus -H $IPMI_HOST -U $USER_NAME -P $IDRAC_PW raw 0x30 0x30 0x01 0x00
# ipmitool -I lanplus -H $IPMI_HOST -U $USER_NAME -P $IDRAC_PW raw 0x30 0x30 0x02 0xff 0x14
