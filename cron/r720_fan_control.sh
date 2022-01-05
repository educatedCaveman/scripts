#!/bin/bash
# TODO: account for temperature in what fan speed to set?

# IDRAC_PW comes from .zsh_secrets
# source $HOME/.zsh_secrets
IPMI_HOST="192.168.1.7"
USER_NAME="idrac_remote"
IDRAC_PW="dFM3pTnMvEEvi5"
IPMI_OPTS="-I lanplus -H $IPMI_HOST -U $USER_NAME -P $IDRAC_PW"
#how many thousands of RPM should the fans be?
TGT_K_RPM="3"

# retrieve fan data. also tests the connection
RESPONSE=$( ipmitool $IPMI_OPTS sdr type fan )
RC=$?

# if we were able to connect, parse the response
if [ $RC -eq 0 ]
then
    AVG_RPM=$( echo $RESPONSE | grep "RPM" | awk '{print $9}' | awk '{s+=$1}END{print s/NR}' )
    krpm=$(( ${AVG_RPM} / 1000 ))

    # if the RPM isn't approx what is desired, change it
    if (( $krpm != $TGT_K_RPM ))
    then
        # echo "will reset the fans"
        ipmitool $IPMI_OPTS raw 0x30 0x30 0x01 0x00
        ipmitool $IPMI_OPTS raw 0x30 0x30 0x02 0xff 0x14
    fi

#TODO: send slack notification?
# would be better to store the state somewhere and only send it if the command doesn't return a result
# would also be good to check the state at the beginning and if it goes back to good, send a different notification
# else
#     echo "error running ipmitool command"
fi


# RPMS=$( ipmitool $IPMI_OPTS sdr type fan | grep "RPM" | awk '{print $9}' )
# AVG_RPM=$( echo $RPMS | awk '{s+=$1}END{print s/NR}' )

# if no response, send slack notification
# if response not in desired state, run commands to put it into desired state
# else, must have received response, and it is satisfactory

# ipmitool $IPMI_OPTS raw 0x30 0x30 0x01 0x00
# ipmitool $IPMI_OPTS raw 0x30 0x30 0x02 0xff 0x14

