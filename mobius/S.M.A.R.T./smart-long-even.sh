#!/bin/bsh
#perform the S.M.A.R.T. tests for all disks in parallel

#variables
RUN="/mnt/storage_node/Backup/logs/S.M.A.R.T./scripts"
DEV="/dev"
ERRFILE="/mnt/storage_node/Backup/logs/S.M.A.R.T./scripts/file.err"
TS=$(date +%F-%T)
LOGFILE="/mnt/storage_node/Backup/logs/S.M.A.R.T./logs/smart.long-even.${TS}.log"

#redirect all output to dynmically named logfile
exec > "${LOGFILE}"
exec 2>&1

#parallel wrapper function:
function parallel-wrapper() {
    #wrapper to parallelize w/ error detection
    bash "${RUN}"/smart-test.sh "${1}" long
    rc=$?
    if [ $rc -ne "0" ];
    then
        echo "script exited w/ non-zero return code."
        touch "${ERRFILE}"
    fi
}

#start our S.M.A.R.T. tests in parallel:
echo "starting S.M.A.R.T. tests..."

parallel-wrapper "${DEV}/da0" &
PID00=$!
parallel-wrapper "${DEV}/da2" &
PID02=$!
parallel-wrapper "${DEV}/da4" &
PID04=$!
parallel-wrapper "${DEV}/da6" &
PID06=$!
parallel-wrapper "${DEV}/da8" &
PID08=$!
parallel-wrapper "${DEV}/da10" &
PID10=$!
parallel-wrapper "${DEV}/da12" &
PID12=$!

#wait for all the processes to be done
echo "all tests started.  waiting for completion..."
wait $PID00 $PID02 $PID04 $PID06 $PID08 $PID10 $PID12
echo "all tests complete."

#error detection
if [[ -e "${ERRFILE}" ]];
then
    echo "an error was encountered during one or more S.M.A.R.T. tests."
    echo "sending email..."
    bash "${RUN}"/smart-fail-email.sh
    echo "done!"
    echo "cleaning up error file..."
    rm "${ERRFILE}" #clean up after ourselves!
    echo "done!"
    echo "exiting..."
    exit 1
fi
echo "no errors detected in tests."

#create a digest of wanted/useful S.M.A.R.T. INFO:
echo "createing S.M.A.R.T. digest..."
bash "${RUN}"/smart-digest.sh
echo "done!"

#send email with S.M.A.R.T INFO:
echo "sending completion email with digest..."
bash "${RUN}"/smart-results-email.sh
echo "done!"
echo "exiting..."
