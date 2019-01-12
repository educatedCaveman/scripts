#!/bin/bash
#script to send an email:
FROM="drake@rclone.vm"
TO="alerts.drake@gmail.com"
SUBJ="RCLONE SYNC STARTED"
PASS="ercooaejucxkyqqf"
STATS="/tmp/rclone-digest.tmp"
MSG="/tmp/rclone.start.email.msg"

echo "the rclone sync started on $(date +%F-%T)." >> "${MSG}"

/usr/bin/sendemail -f "${FROM}" -t "${TO}" -u "${SUBJ}" -o message-file="${MSG}" -s smtp.gmail.com:587 -xu "${TO}" -xp "${PASS}" -o tls=yes

rm "${MSG}"
