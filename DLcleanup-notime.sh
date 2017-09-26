#!/bin/bash

pics="/media/storage/Pictures/temp/"
downloads="/home/drake/Downloads/"
video="/media/storage/Videos/"
zip="/media/storage/Pictures/picArchives/"
archives="/home/drake/archives/"
ISO="/media/storage/ISOs/"

cd $downloads   #just in case i move this later...

rename "s/ /_/g" /home/drake/Downloads/*

#images
for file in *.jpg *.jpeg *.JPG *.JPEG *.png *.gif *Imgur.zip
do
    if [ -e "$file" ]
    then
    #mv -- "$f" $pics
    find $downloads$file -type f -exec mv '{}' $pics \;
    fi
done


#videos
for file in *.mp4 *.MP4 *.webm *.flv *.gifv *.swf *.mov
do
    if [ -e "$file" ]
    then
    #mv -- "$f" $video
    find $downloads$file -type f -exec mv '{}' $video \;
    fi
done

#zipfiles
for file in *.zip
do
    if [ -e "$file" ]
    then
    #mv -- "$f" $zip
    find $downloads$file -type f -exec mv '{}' $zip \;
    fi
done

#archives
for file in *.deb *.tar.gz *.xz
do
    if [ -e "$file" ]
    then
    #mv -- "$f" $archives
    find $downloads$file -type f -exec mv '{}' $archives \;
    fi
done

#ISOs/images
for file in *.iso *.img
do
    if [ -e "$file" ]
    then
    #mv -- "$f" $ISO
    find $downloads$file -type f -exec mv '{}' $ISO \;
    fi
done

for file in *.crdownload
do
    if [ -e "$file" ]
    then
        find $downloads$file -type f -exec rm '{}' \;
    fi
done

 
