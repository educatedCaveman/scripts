#!/bin/bash
#script to send an email:
FROM="drake@rclone.vm"
TO="alerts.drake@gmail.com"
SUBJ="RCLONE SYNC COMPLETE"
PASS="ercooaejucxkyqqf"
STATS="/tmp/rclone-digest.tmp"
MSG="/tmp/rclone.email.msg"
RCLONELOG=$(ls -1qt "${HOME}"/logs/*.log | head -1)
CONTROLLOG=$(ls -1qt "${HOME}"/logs/control/*.log | head -1)

echo "the rclone sync completed with no detected errors" >> "${MSG}"
echo "please check the attached logfile(s)" >> "${MSG}"
echo "a summary of the stats is listed below:" >> "${MSG}"
echo "" >> "${MSG}"
cat "${STATS}" >> "${MSG}"

#sendemail -f drake@rclone.vm -t alerts.drake@gmail.com -u "testing" -m "testing sending an email from command line" -s smtp.gmail.com:587 -xu alerts.drake@gmail.com -xp "ercooaejucxkyqqf" -o tls=yes

#/usr/bin/sendemail -f "${FROM}" -t "${TO}" -u "${SUBJ}" -m "${MESG}" -s smtp.gmail.com:587 -xu "${TO}" -xp "${PASS}" -o tls=yes
/usr/bin/sendemail -f "${FROM}" -t "${TO}" -u "${SUBJ}" -o message-file="${MSG}" -a "${CONTROLLOG}" -a "${RCLONELOG}" -s smtp.gmail.com:587 -xu "${TO}" -xp "${PASS}" -o tls=yes
