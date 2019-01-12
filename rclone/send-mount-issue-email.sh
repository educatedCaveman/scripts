#!/bin/bash
#script to send an email:
FROM="drake@rclone.vm"
TO="alerts.drake@gmail.com"
SUBJ="RCLONE FAILED - 1 or more drives not mounted"
MESG=""
PASS="ercooaejucxkyqqf"
ERRMSG=/tmp/rclone.issue.msg

echo "the rclone sync was never started becuase one or more network drives wasn't mounted." >> "${ERRMSG}"
echo "please investigate manually." >> "${ERRMSG}"
echo "the output of 'df -h' is shown below" >> "${ERRMSG}"
echo "" >> "${ERRMSG}"
df -h >> "${ERRMSG}"

#sendemail -f drake@rclone.vm -t alerts.drake@gmail.com -u "testing" -m "testing sending an email from command line" -s smtp.gmail.com:587 -xu alerts.drake@gmail.com -xp "ercooaejucxkyqqf" -o tls=yes

#/usr/bin/sendemail -f "${FROM}" -t "${TO}" -u "${SUBJ}" -m "${MESG}" -s smtp.gmail.com:587 -xu "${TO}" -xp "${PASS}" -o tls=yes
/usr/bin/sendemail -f "${FROM}" -t "${TO}" -u "${SUBJ}" -o message-file="${ERRMSG}" -s smtp.gmail.com:587 -xu "${TO}" -xp "${PASS}" -o tls=yes

rm "${ERRMSG}"
