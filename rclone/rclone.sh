#!/bin/bash
#main script to backup using rclone
CONTROLLOG="${HOME}/logs/control/rclone.control.$(date +%F-%T).log"

exec > "${CONTROLLOG}"
exec 2>&1

#first, check if the network drives are mounted:
sh "${HOME}"/scripts/rclone/check-net-drives.sh
rc=$?
echo "" #for formatting

#if all drives arent mounted, send email, and exit
if [ "${rc}" -ne "0" ];
then
    echo "prev script had non-zero return code"
    #send email here
    sh "${HOME}"/scripts/rclone/send-mount-issue-email.sh
    exit 1
else
    sh "${HOME}"/scripts/rclone/send-rclone-start-email.sh
fi

#if all drives ARE mounted, proceed with the rlcone script
begin=$(date +%s)
#script goes here:
#sleep 2    #for testing only
sh "${HOME}"/scripts/rclone/sync.sh
end=$(date +%s)
duration=$(expr $end - $begin)
#for some reason just passing the seconds to it fails miserably...
h=$(($duration/3600))
m=$(($duration%3600/60))
s=$(($duration%60))
printf "rclone sync completed on: $(date +%F-%T)\n"
printf "time elapsed %ss, or %02d:%02d:%02d (hh:mm:ss)\n" $duration $h $m $s

#when rclone is complete, get digest of logfile:
sh "${HOME}"/scripts/rclone/digest.sh

#send email with stats and logfiles.
sh "${HOME}"/scripts/rclone/send-rclone-complete-email.sh
rc=$?

#if email was successful, delete message file and stats tmp files
#else leave them in place
if [ "${rc}" -eq "0" ];
then
    #remove our rclone tmp files (email message and stats file)
    rm /tmp/rclone*
fi

