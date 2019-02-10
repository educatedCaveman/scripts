#!/bin/bash
#variables:
DISK=''             #the disk to test, yet to be assigned
NEXT=''             #an error checking string, yet to be assigned
TEST=''             #the type of test to be run, yet to be assigned
TIMEOUT=5           #how long to wait before checking S.M.A.R.T. again
TIMEOUTLONG=600     #how long to wait before checking, if running a long test
TIMEOUTCNT=72       #how many timeouts before exiting
SLEEPLONG=60000     #how long to wait before even starting to check for a long test
SLEEPSHORT=120      #how long to wait before even starting to check for a short test
STATUS=''           #the status of the current test, yet to be assigned
DONESTATUS="0)"     #the known complete status to compare against

#error handling:
if [[ $# -ne 2 ]];
then
    echo "wrong number of arguments!"
    echo "exiting..."
    exit 1
fi

#do the needful
DISK=$1     #our 1st argument is the disk to be tested
TEST=$2     #our 2nd argument is the test type

#does our disk exist?
if [[ ! -e "${DISK}" ]];
then
    echo "disk ${DISK} doesn't exist"
    exit 1
fi

#is the provided test type valid?
if [[ "${TEST}" != "short" ]] && [[ "${TEST}" != "long" ]];
then
    echo "provided test type (${TEST}) for ${DISK} is not valid.  exiting..."
    exit 1
fi

#smart test
#we don't want to see its output.  its messages aren't very useful
rc=0
if [[ "${TEST}" == "short" ]];
then
    #perform short test
    smartctl -t short "${DISK}" > /dev/null
    rc=$?
else
    #perform long test
    smartctl -t long "${DISK}" > /dev/null
    rc=$?
fi

#check the return code of the smartctl command, and wait, if applicable
if [ $rc -ne "0" ]; then
    echo "S.M.A.R.T. test for ${DISK} encountered an error. please investigate manually"
    exit 1
else
    echo "waiting a while for tests to run for ${DISK}..."
    if [[ "${TEST}" == "short" ]];
    then
        sleep "${SLEEPSHORT}"       #about how long smart says it should take (2m)
    else
        sleep "${SLEEPLONG}"        #about how long a long test says it should take (994m)
        TIMEOUT="${TIMEOUTLONG}"    #reset the timout time to 10m
    fi
fi

#waiting for smart to finish.  either manually
STATUS=$(smartctl -c "${DISK}" | grep "Self-test execution status:" | awk '{print $5}')

#while the current status <> the done status, wait, but only for so long
counter=0
while [[ "${STATUS}" != "${DONESTATUS}" ]]
do
    #timout condition:
    #72*5=360s=6m   72*600=43200s=12h
    if [[ $counter -gt $TIMEOUTCNT ]];
    then
        echo "taking a while to run test for ${DISK}.  exiting..."
        break
    fi
    counter=$(( $counter + 1 ))
    #if we havent timed out, wait, then update our status
    echo "still running smart test for ${DISK}..."
    sleep "${TIMEOUT}"
    STATUS=$(smartctl -c "${DISK}" | grep "Self-test execution status:" | awk '{print $5}')
done

#check if new entry is in the expected format
#we're expecting the field pulled in (lifetime hours) to be numeric
#even if it fails, we don't want to exit the script.  we just want to note it.
NEXT=$(smartctl -l selftest "${DISK}" | grep "# 1" | awk '{print $9}')
isNUM='^[0-9]+$'
if ! [[ ${NEXT} =~ ${isNUM} ]]; then
    echo "error occured in S.M.A.R.T. test for ${DISK}.  please investigate manually"
else
    echo "S.M.A.R.T. test for ${DISK} appears to have completed normally.  please investigate manually"
fi
