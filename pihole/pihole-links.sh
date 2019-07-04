#!/bin/bash
home=/home/drake
PIHOLE=/etc/pihole
GIT=$home/dotfiles/pihole
ADLIST=adlists.list
WHITELIST=whitelist.txt
BLACKLIST=blacklist.txt
FTL=pihole-FTL.conf
REGEX=regex.list
BACKUP=$home/pihole_backup/$(date +%F-%T)

function rectify_link {
    #   - backup git repo file:
    #   - backup pihole file
    #   - overwrite git file with pihole file
    #   - remove pihole file
    #   - create link from git to pihole

    FILE=$1
    
    mkdir -p "${BACKUP}/git"
    mkdir -p "${BACKUP}/pihole"
    cp "${GIT}/${FILE}" "${BACKUP}/git/${FILE}"
    cp "${PIHOLE}/${FILE}" "${BACKUP}/pihole/${FILE}"
    cat "${PIHOLE}/${FILE}" > "${GIT}/${FILE}"
    rm "${PIHOLE}/${FILE}"
    ln -s "${GIT}/${FILE}" "${PIHOLE}/${FILE}"

}

#adlists
if ! [[ -L "${PIHOLE}/${ADLIST}" ]];
then
    rectify_link "${ADLIST}"
fi

#whitelist
if ! [[ -L "${PIHOLE}/${WHITELIST}" ]];
then
    rectify_link "${WHITELIST}"
fi

#blacklist
if ! [[ -L "${PIHOLE}/${BLACKLIST}" ]];
then
    rectify_link "${BLACKLIST}"
fi

#ftl
if ! [[ -L "${PIHOLE}/${FTL}" ]];
then
    rectify_link "${FTL}"
fi

#regex
if ! [[ -L "${PIHOLE}/${REGEX}" ]];
then
    rectify_link "${REGEX}"
fi


