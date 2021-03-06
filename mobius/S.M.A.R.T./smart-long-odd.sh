#!/bin/bsh
#perform the S.M.A.R.T. tests for all disks in parallel

#variables
RUN="/mnt/storage_node/Backup/logs/S.M.A.R.T./scripts"
DEV="/dev"
ERRFILE="/mnt/storage_node/Backup/logs/S.M.A.R.T./scripts/file.err"
TS=$(date +%F-%T)
LOGFILE="/mnt/storage_node/Backup/logs/S.M.A.R.T./logs/smart.long.odd.${TS}.log"

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

parallel-wrapper "${DEV}/da1" &
PID01=$!
parallel-wrapper "${DEV}/da3" &
PID03=$!
parallel-wrapper "${DEV}/da5" &
PID05=$!
parallel-wrapper "${DEV}/da7" &
PID07=$!
parallel-wrapper "${DEV}/da9" &
PID09=$!
parallel-wrapper "${DEV}/da11" &
PID11=$!
parallel-wrapper "${DEV}/da13" &
PID13=$!

#wait for all the processes to be done
echo "all tests started.  waiting for completion..."
wait $PID01 $PID03 $PID05 $PID07 $PID09 $PID11 $PID13
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
