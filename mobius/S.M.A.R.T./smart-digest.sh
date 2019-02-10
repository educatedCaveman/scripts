#!/bin/bash
#script to save all smart info and create a digest for emailing
#variables:
DEV="/dev"
WORKDIR="/mnt/storage_node/Backup/logs/S.M.A.R.T."
TS=$(date +%F-%T)
LOGDIR="${WORKDIR}/${TS}"
STATSFILE="${WORKDIR}/${TS}.stats"
NUM=99  #not the best way to go about this...

#logfile paths (will be reused):
DA0="${LOGDIR}/da0.smart.${TS}.txt"
DA1="${LOGDIR}/da1.smart.${TS}.txt"
DA2="${LOGDIR}/da2.smart.${TS}.txt"
DA3="${LOGDIR}/da3.smart.${TS}.txt"
DA4="${LOGDIR}/da4.smart.${TS}.txt"
DA5="${LOGDIR}/da5.smart.${TS}.txt"
DA6="${LOGDIR}/da6.smart.${TS}.txt"
DA7="${LOGDIR}/da7.smart.${TS}.txt"
DA8="${LOGDIR}/da8.smart.${TS}.txt"
DA9="${LOGDIR}/da9.smart.${TS}.txt"
DA10="${LOGDIR}/da10.smart.${TS}.txt"
DA11="${LOGDIR}/da11.smart.${TS}.txt"
DA12="${LOGDIR}/da12.smart.${TS}.txt"
DA13="${LOGDIR}/da13.smart.${TS}.txt"

#create all-info files
mkdir "${LOGDIR}"
smartctl -a "${DEV}"/da0 > "${DA0}"
smartctl -a "${DEV}"/da1 > "${DA1}"
smartctl -a "${DEV}"/da2 > "${DA2}"
smartctl -a "${DEV}"/da3 > "${DA3}"
smartctl -a "${DEV}"/da4 > "${DA4}"
smartctl -a "${DEV}"/da5 > "${DA5}"
smartctl -a "${DEV}"/da6 > "${DA6}"
smartctl -a "${DEV}"/da7 > "${DA7}"
smartctl -a "${DEV}"/da8 > "${DA8}"
smartctl -a "${DEV}"/da9 > "${DA9}"
smartctl -a "${DEV}"/da10 > "${DA10}"
smartctl -a "${DEV}"/da11 > "${DA11}"
smartctl -a "${DEV}"/da12 > "${DA12}"
smartctl -a "${DEV}"/da13 > "${DA13}"
#da14 excluded bc its the boot drive, and doesn't appear to support S.M.A.R.T.

#TODO:  create digest
#serial numbers:
DA0_serial=$(grep "Serial" < "${DA0}" | awk '{print $3}')
DA1_serial=$(grep "Serial" < "${DA1}" | awk '{print $3}')
DA2_serial=$(grep "Serial" < "${DA2}" | awk '{print $3}')
DA3_serial=$(grep "Serial" < "${DA3}" | awk '{print $3}')
DA4_serial=$(grep "Serial" < "${DA4}" | awk '{print $3}')
DA5_serial=$(grep "Serial" < "${DA5}" | awk '{print $3}')
DA6_serial=$(grep "Serial" < "${DA6}" | awk '{print $3}')
DA7_serial=$(grep "Serial" < "${DA7}" | awk '{print $3}')
DA8_serial=$(grep "Serial" < "${DA8}" | awk '{print $3}')
DA9_serial=$(grep "Serial" < "${DA9}" | awk '{print $3}')
DA10_serial=$(grep "Serial" < "${DA10}" | awk '{print $3}')
DA11_serial=$(grep "Serial" < "${DA11}" | awk '{print $3}')
DA12_serial=$(grep "Serial" < "${DA12}" | awk '{print $3}')
DA13_serial=$(grep "Serial" < "${DA13}" | awk '{print $3}')

#overall health assessment:
DA0_health=$(grep "SMART overall-health self-assessment test result:" < "${DA0}" | awk '{print $6}')
DA1_health=$(grep "SMART overall-health self-assessment test result:" < "${DA1}" | awk '{print $6}')
DA2_health=$(grep "SMART overall-health self-assessment test result:" < "${DA2}" | awk '{print $6}')
DA3_health=$(grep "SMART overall-health self-assessment test result:" < "${DA3}" | awk '{print $6}')
DA4_health=$(grep "SMART overall-health self-assessment test result:" < "${DA4}" | awk '{print $6}')
DA5_health=$(grep "SMART overall-health self-assessment test result:" < "${DA5}" | awk '{print $6}')
DA6_health=$(grep "SMART overall-health self-assessment test result:" < "${DA6}" | awk '{print $6}')
DA7_health=$(grep "SMART overall-health self-assessment test result:" < "${DA7}" | awk '{print $6}')
DA8_health=$(grep "SMART overall-health self-assessment test result:" < "${DA8}" | awk '{print $6}')
DA9_health=$(grep "SMART overall-health self-assessment test result:" < "${DA9}" | awk '{print $6}')
DA10_health=$(grep "SMART overall-health self-assessment test result:" < "${DA10}" | awk '{print $6}')
DA11_health=$(grep "SMART overall-health self-assessment test result:" < "${DA11}" | awk '{print $6}')
DA12_health=$(grep "SMART overall-health self-assessment test result:" < "${DA12}" | awk '{print $6}')
DA13_health=$(grep "SMART overall-health self-assessment test result:" < "${DA13}" | awk '{print $6}')

#temp:
DA0_temp=$(grep "Temperature_Celsius" < "${DA0}" | awk '{print $10}')
DA1_temp=$(grep "Temperature_Celsius" < "${DA1}" | awk '{print $10}')
DA2_temp=$(grep "Temperature_Celsius" < "${DA2}" | awk '{print $10}')
DA3_temp=$(grep "Temperature_Celsius" < "${DA3}" | awk '{print $10}')
DA4_temp=$(grep "Temperature_Celsius" < "${DA4}" | awk '{print $10}')
DA5_temp=$(grep "Temperature_Celsius" < "${DA5}" | awk '{print $10}')
DA6_temp=$(grep "Temperature_Celsius" < "${DA6}" | awk '{print $10}')
DA7_temp=$(grep "Temperature_Celsius" < "${DA7}" | awk '{print $10}')
DA8_temp=$(grep "Temperature_Celsius" < "${DA8}" | awk '{print $10}')
DA9_temp=$(grep "Temperature_Celsius" < "${DA9}" | awk '{print $10}')
DA10_temp=$(grep "Temperature_Celsius" < "${DA10}" | awk '{print $10}')
DA11_temp=$(grep "Temperature_Celsius" < "${DA11}" | awk '{print $10}')
DA12_temp=$(grep "Temperature_Celsius" < "${DA12}" | awk '{print $10}')
DA13_temp=$(grep "Temperature_Celsius" < "${DA13}" | awk '{print $10}')

#smart test result history
DA0_hist=$(smartctl -l selftest /dev/da0 | grep "Num" -A "${NUM}")
DA1_hist=$(smartctl -l selftest /dev/da1 | grep "Num" -A "${NUM}")
DA2_hist=$(smartctl -l selftest /dev/da2 | grep "Num" -A "${NUM}")
DA3_hist=$(smartctl -l selftest /dev/da3 | grep "Num" -A "${NUM}")
DA4_hist=$(smartctl -l selftest /dev/da4 | grep "Num" -A "${NUM}")
DA5_hist=$(smartctl -l selftest /dev/da5 | grep "Num" -A "${NUM}")
DA6_hist=$(smartctl -l selftest /dev/da6 | grep "Num" -A "${NUM}")
DA7_hist=$(smartctl -l selftest /dev/da7 | grep "Num" -A "${NUM}")
DA8_hist=$(smartctl -l selftest /dev/da8 | grep "Num" -A "${NUM}")
DA9_hist=$(smartctl -l selftest /dev/da9 | grep "Num" -A "${NUM}")
DA10_hist=$(smartctl -l selftest /dev/da10 | grep "Num" -A "${NUM}")
DA11_hist=$(smartctl -l selftest /dev/da11 | grep "Num" -A "${NUM}")
DA12_hist=$(smartctl -l selftest /dev/da12 | grep "Num" -A "${NUM}")
DA13_hist=$(smartctl -l selftest /dev/da13 | grep "Num" -A "${NUM}")

#creating the stats file:
echo "overall S.M.A.R.T. stats:" > "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "DEV    SERIAL            HEALTH   TEMP (C)" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "da0    ${DA0_serial}          ${DA0_health}   ${DA0_temp}" >> "${STATSFILE}"
echo "da1    ${DA1_serial}          ${DA1_health}   ${DA1_temp}" >> "${STATSFILE}"
echo "da2    ${DA2_serial}   ${DA2_health}   ${DA2_temp}" >> "${STATSFILE}"
echo "da3    ${DA3_serial}   ${DA3_health}   ${DA3_temp}" >> "${STATSFILE}"
echo "da4    ${DA4_serial}   ${DA4_health}   ${DA4_temp}" >> "${STATSFILE}"
echo "da5    ${DA5_serial}   ${DA5_health}   ${DA5_temp}" >> "${STATSFILE}"
echo "da6    ${DA6_serial}   ${DA6_health}   ${DA6_temp}" >> "${STATSFILE}"
echo "da7    ${DA7_serial}   ${DA7_health}   ${DA7_temp}" >> "${STATSFILE}"
echo "da8    ${DA8_serial}   ${DA8_health}   ${DA8_temp}" >> "${STATSFILE}"
echo "da9    ${DA9_serial}   ${DA9_health}   ${DA9_temp}" >> "${STATSFILE}"
echo "da10   ${DA10_serial}   ${DA10_health}   ${DA10_temp}" >> "${STATSFILE}"
echo "da11   ${DA11_serial}   ${DA11_health}   ${DA11_temp}" >> "${STATSFILE}"
echo "da12   ${DA12_serial}   ${DA12_health}   ${DA12_temp}" >> "${STATSFILE}"
echo "da13   ${DA13_serial}   ${DA13_health}   ${DA13_temp}" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"

#history:
echo "da0 S.M.A.R.T. test history:" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "${DA0_hist}" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"

echo "da1 S.M.A.R.T. test history:" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "${DA1_hist}" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"

echo "da2 S.M.A.R.T. test history:" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "${DA2_hist}" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"

echo "da3 S.M.A.R.T. test history:" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "${DA3_hist}" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"

echo "da4 S.M.A.R.T. test history:" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "${DA4_hist}" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"

echo "da5 S.M.A.R.T. test history:" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "${DA5_hist}" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"

echo "da6 S.M.A.R.T. test history:" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "${DA6_hist}" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"

echo "da7 S.M.A.R.T. test history:" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "${DA7_hist}" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"

echo "da8 S.M.A.R.T. test history:" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "${DA8_hist}" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"

echo "da9 S.M.A.R.T. test history:" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "${DA9_hist}" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"

echo "da10 S.M.A.R.T. test history:" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "${DA10_hist}" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"

echo "da11 S.M.A.R.T. test history:" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "${DA11_hist}" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"

echo "da12 S.M.A.R.T. test history:" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "${DA12_hist}" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"

echo "da13 S.M.A.R.T. test history:" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "${DA13_hist}" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> "${STATSFILE}"
echo "" >> "${STATSFILE}"
