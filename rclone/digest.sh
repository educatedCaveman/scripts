#!/bin/bash
#summarizes the rclone sync logfile
LOGSDIR="/home/drake/logs"
LOGFILE=$(ls -1qt "${LOGSDIR}"/*.log | head -1)
TMPFILE="/tmp/rclone-digest.tmp"

#error counts:
ERRCNT=$(grep "ERROR" "${LOGFILE}" | wc -l)
PERMISSIONERRCNT=$(grep "ERROR" "${LOGFILE}" | grep "permission denied" | wc -l)
IOERRCNT=$(grep "ERROR" "${LOGFILE}" | grep "IO error" | wc -l)
RATEERRCNT=$(grep "ERROR" "${LOGFILE}" | grep -E "rateLimitExceeded|userRateLimitExceeded" | wc -l)
OTHERERR=$(grep "ERROR" "${LOGFILE}" | grep -v "permission denied" | grep -v "IO error" | grep -v -E "rateLimitExceeded|userRateLimitExceeded")
OTHERERRCNT=$(grep "ERROR" "${LOGFILE}" | grep -v "permission denied" | grep -v "IO error" | grep -v -E "rateLimitExceeded|userRateLimitExceeded" | wc -l)

#notice counts:
NOTICECNT=$(grep "NOTICE" "${LOGFILE}" | wc -l)
DUPOBJNOTICECNT=$(grep "NOTICE" "${LOGFILE}" | grep "Duplicate object" | wc -l)
OTHERNOTICE=$(grep "NOTICE" "${LOGFILE}" | grep -v "Duplicate object")
OTHERNOTICECNT=$(grep "NOTICE" "${LOGFILE}" | grep -v "Duplicate object" | wc -l) 

#stats:
printf "error count:      \t${ERRCNT}\n" > "$TMPFILE"
printf "permission errors:\t${PERMISSIONERRCNT}\n" >> "${TMPFILE}"
printf "IO errors:        \t${IOERRCNT}\n" >> "${TMPFILE}"
printf "Rate Limit Errors:\t${RATEERRCNT}\n" >> "${TMPFILE}"
printf "other errors:     \t${OTHERERRCNT}\n" >> "${TMPFILE}"
printf "${OTHERERR}\n\n" >> "${TMPFILE}"

printf "notice count:     \t${NOTICECNT}\n" >> "${TMPFILE}"
printf "duplicate objects:\t${DUPOBJNOTICECNT}\n" >> "${TMPFILE}"
printf "other notices:    \t${OTHERNOTICECNT}\n" >> "${TMPFILE}"
printf "${OTHERNOTICE}\n\n" >> "${TMPFILE}"
