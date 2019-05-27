#!/bin/bash
PICS="/media/storage/Pictures/temp/"
DOWNLOADS="/home/drake/Downloads/"
VIDEO="/media/storage/Videos/"
#zip="/media/storage/Pictures/picArchives/"
ARCHIVES="/home/drake/archives/"
ISO="/media/storage/ISOs/"
ZIP="/media/storage/Pictures/temp/imgur_zips/"

#needed for the find statements to work
cd "${DOWNLOADS}"

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

#images
for file in *.jpg *.jpeg *.JPG *.JPEG *.png *.gif
do
    if [ -e "${file}" ]
    then
    find "${DOWNLOADS}${file}" -type f -mtime +2 -exec mv '{}' "${PICS}" \;
    fi
done

#videos
for file in *.mp4 *.MP4 *.webm *.flv *.gifv *.swf *.mov
do
    if [ -e "${file}" ]
    then
    find "${DOWNLOADS}${file}" -type f -mtime +2 -exec mv '{}' "${VIDEO}" \;
    fi
done

##zipfiles
#for file in *.zip
#do
#    if [ -e "${file}" ]
#    then
#    find "${DOWNLOADS}${file}" -type f -mtime +2 -exec mv '{}' "${zip}" \;
#    fi
#done

#Imgur zipfiles
for file in Imgur*.zip *Imgur.zip
do
    if [ -e "${file}" ]
    then
    find "${DOWNLOADS}${file}" -type f -mtime +2 -exec mv '{}' "${ZIP}" \;
    fi
done

#archives
for file in *.deb *.tar.gz *.xz *.zip
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

#for file in *.crdownload
#do
#    if [ -e "${file}" ]
#    then
#        find "${DOWNLOADS}${file}" -type f -mtime +2 -exec rm '{}' \;
#    fi
#done

 
