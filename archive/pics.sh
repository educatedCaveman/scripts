#!/bin/bash

dest="/home/drake/Pictures/temp/"
downloads="/home/drake/Downloads/"

cd $downloads   #just in case i move this later...

#make things easier for mv
rename "s/ /_/g" *

#.jpg
for f in *.jpg
do
if [ -e $f ]    #only proceed if file exists
    then
    mv $f $dest    #move file to temp pictures folder
    fi
done

#.jpeg
for f in *.jpeg
do
    if [ -e $f ]
    then
    mv $f $dest
    fi
done

#.JPG
for f in *.JPG
do
    if [ -e $f ]
    then
    mv $f $dest
    fi
done

#.JPEG
for f in *.JPEG
do
    if [ -e $f ]
    then
    mv $f $dest
    fi
done

#.png
for f in *.png
do
    if [ -e $f ]
    then
    mv $f $dest
    fi
done

#.gif
for f in *.gif
do
    if [ -e $f ]
    then
    mv $f $dest
    fi
done
