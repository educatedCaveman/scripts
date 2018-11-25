#!/bin/bash

pics="/media/storage/Pictures/temp/"
downloads="/home/drake/Downloads/"
video="/media/storage/Videos/"
zip="/media/storage/Pictures/picArchives/"
archives="/home/drake/archives/"
ISO="/media/storage/ISOs/"

cd "${downloads}"   #just in case i move this later...
#/home/drake/scripts/DLfilenames.sh
#rm *\(1\)*

#shouldn't be needed now
#rename "s/ /_/g" *

#images
for file in *.jpg *.jpeg *.JPG *.JPEG *.png *.gif *Imgur.zip
do
    if [ -e "${file}" ]
    then
    find "${downloads}${file}" -type f -mtime +2 -exec mv '{}' "${pics}" \;
    fi
done

#videos
for file in *.mp4 *.MP4 *.webm *.flv *.gifv *.swf *.mov
do
    if [ -e "${file}" ]
    then
    find "${downloads}${file}" -type f -mtime +2 -exec mv '{}' "${video}" \;
    fi
done

#zipfiles
for file in *.zip
do
    if [ -e "${file}" ]
    then
    find "${downloads}${file}" -type f -mtime +2 -exec mv '{}' "${zip}" \;
    fi
done

#archives
for file in *.deb *.tar.gz *.xz
do
    if [ -e "${file}" ]
    then
    find "${downloads}${file}" -type f -mtime +2 -exec mv '{}' "${archives}" \;
    fi
done

#ISOs/images
for file in *.iso *.img
do
    if [ -e "${file}" ]
    then
    find "${downloads}${file}" -type f -mtime +2 -exec mv '{}' "${ISO}" \;
    fi
done

for file in *.crdownload
do
    if [ -e "${file}" ]
    then
        find "${downloads}${file}" -type f -mtime +2 -exec rm '{}' \;
    fi
done

 
