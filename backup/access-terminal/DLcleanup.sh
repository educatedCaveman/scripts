#!/bin/bash
DOWNLOADS="/home/drake/Downloads/"
PORN_VIDS="/media/mobius/pr0n/video/"
PORN_PICS="/media/mobius/pr0n/pics/"
ZIP="/media/mobius/pr0n/imgur_zips/"
ARCHIVES="/media/mobius/Backup/archives/"
ISO="/media/mobius/Backup/ISOs/"
PFSENSE_CONFIG="/media/mobius/Backup/pfsense/"
FREENAS_DB="/media/mobius/Backup/freenas/"
BACKUP=$(df | grep "Backup")
PORN=$(df | grep "pr0n")
FREENAS_DROPBOX="/home/drake/Dropbox"

if [ -z "${BACKUP}" ];
then
    echo "Backup not mounted"
    exit 1
fi

if [ -z "${PORN}" ];
then 
    echo "porn not mounted"
    exit 1
fi

#needed for the find statements to work, even when given absolute paths
cd "${DOWNLOADS}"   #just in case i move this later...

#pfsense xml files: COPY only
for file in config-*.xml
do
    if [ -e "${file}" ]
    then
    find "${DOWNLOADS}${file}" -type f -mtime +2 -exec cp '{}' "${PFSENSE_CONFIG}" \;
    fi
done

#FreeNAS:  COPY only!
for file in *-FreeNAS-*.db
do
    if [ -e "${file}" ]
    then
    find "${DOWNLOADS}${file}" -type f -mtime +2 -exec cp '{}' "${FREENAS_DB}" \;
    find "${DOWNLOADS}${file}" -type f -mtime +2 -exec cp '{}' "${FREENAS_DROPBOX}" \;
    fi
done

#images
for file in *.jpg *.jpeg *.JPG *.JPEG *.png *.gif *Imgur.zip
do
    if [ -e "${file}" ]
    then
    find "${DOWNLOADS}${file}" -type f -mtime +2 -exec mv '{}' "${PORN_PICS}" \;
    fi
done

#videos
for file in *.mp4 *.MP4 *.webm *.flv *.gifv *.swf *.mov
do
    if [ -e "${file}" ]
    then
    find "${DOWNLOADS}${file}" -type f -mtime +2 -exec mv '{}' "${PORN_VIDS}" \;
    fi
done

#Imgur zipfiles
for file in Imgur*.zip
do
    if [ -e "${file}" ]
    then
    find "${DOWNLOADS}${file}" -type f -mtime +2 -exec mv '{}' "${ZIP}" \;
    fi
done

#archives (including non-Imgur zipfiles
for file in *.zip *.deb *.tar.gz *.xz
do
    if [ -e "${file}" ]
    then
    find "${DOWNLOADS}${file}" -type f -mtime +2 -exec mv '{}' "${ARCHIVES}" \;
    fi
done

#ISOs/images
for file in *.iso *.img
do
    if [ -e "${file}" ]
    then
    find "${DOWNLOADS}${file}" -type f -mtime +2 -exec mv '{}' "${ISO}" \;
    fi
done
