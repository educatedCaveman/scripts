#!/bin/bash

IPMI_HOST="192.168.1.7"
USER_NAME="idrac_remote"
# IDRAC_PW comes from .zsh_secrets
source $HOME/.zsh_secrets

#TODO: add check for current state, and only update if not in desired state
ipmitool -I lanplus -H $IPMI_HOST -U $USER_NAME -P $IDRAC_PW raw 0x30 0x30 0x01 0x00
ipmitool -I lanplus -H $IPMI_HOST -U $USER_NAME -P $IDRAC_PW raw 0x30 0x30 0x02 0xff 0x14
