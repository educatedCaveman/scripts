#!/bin/bash
SUBJ="S.M.A.R.T. tests completed - mobius.srv"
EMAIL="alerts.drake@gmail.com"
WORKDIR="/mnt/storage_node/Backup/logs/S.M.A.R.T."
STATFILE=$(ls -1qt "${WORKDIR}"/*.stats | head -1)
BODYFILE="${WORKDIR}/smart-email.$(date +%F-%T).txt"

cat "${STATFILE}" > "${BODYFILE}"
echo "" >> "${BODYFILE}"  #needed for mail to know input is done

/usr/bin/mail -s "${SUBJ}" "${EMAIL}" < "${BODYFILE}"

rm "${BODYFILE}"    #always dispose of the bodies
rm "${STATFILE}"
