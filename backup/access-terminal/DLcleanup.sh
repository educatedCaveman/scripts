#!/bin/bash
DOWNLOADS="/home/drake/Downloads/"
PORN_VIDS="/mnt/mobius/pr0n/video/"
PORN_PICS="/mnt/mobius/pr0n/pics/"
ZIP="/mnt/mobius/pr0n/imgur_zips/"
ARCHIVES="/mnt/mobius/Backup/archives/"
ISO="/mnt/mobius/Backup/ISOs/"
PFSENSE_CONFIG="/mnt/mobius/Backup/pfsense/"
FREENAS_DB="/mnt/mobius/Backup/freenas/"
BACKUP=$(df | grep "Backup")
PORN=$(df | grep "pr0n")
FREENAS_DROPBOX="/home/drake/Dropbox/freenas/"

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

#clean up image filenames:
#trim off things after the extension
for file in *.jpg?*
do
    if [ -e "${file}" ]
    then
        mv "${file}" $(ls "${file}" | sed 's/jpg.*/jpg/')
    fi
done
for file in *.jpeg?*
do
    if [ -e "${file}" ]
    then
        mv "${file}" $(ls "${file}" | sed 's/jpeg.*/jpeg/')
    fi
done
for file in *.JPG?*
do
    if [ -e "${file}" ]
    then
        mv "${file}" $(ls "${file}" | sed 's/JPG.*/JPG/')
    fi
done
for file in *.JPEG?*
do
    if [ -e "${file}" ]
    then
        mv "${file}" $(ls "${file}" | sed 's/JPEG.*/JPEG/')
    fi
done
for file in *.png?*
do
    if [ -e "${file}" ]
    then
        mv "${file}" $(ls "${file}" | sed 's/png.*/png/')
    fi
done
for file in *.gif?*
do
    if [ -e "${file}" ]
    then
        mv "${file}" $(ls "${file}" | sed 's/gif.*/gif/')
    fi
done

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
