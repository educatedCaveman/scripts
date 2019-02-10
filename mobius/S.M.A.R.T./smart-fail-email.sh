#!/bin/bash
SUBJ="one or more S.M.A.R.T. failed - mobius.srv"
EMAIL="alerts.drake@gmail.com"
WORKDIR="/mnt/storage_node/Backup/logs/S.M.A.R.T."
BODYFILE="${WORKDIR}/fail-email.$(date +%F-%T).txt"

#create our email here:
echo "an error occured during the S.M.A.R.T. tests.  investigate logfiles manually" > "${BODYFILE}"
echo "" >> "${BODYFILE}"
echo "logs directory:  ${WORKDIR}/logs/" >> "${BODYFILE}"
echo "" >> "${BODYFILE}"  #needed for mail to know input is done

/usr/bin/mail -s "${SUBJ}" "${EMAIL}" < "${BODYFILE}"

rm "${BODYFILE}"    #always dispose of the bodies
