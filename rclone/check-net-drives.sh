#!/bin/bash
#check that the required network drives are mounted:
TEST=$(df | grep "test")
BACKUP=$(df | grep "Backup")
DOCS=$(df | grep "Documents")
HEGRE=$(df | grep "Hegre")
MUSIC=$(df | grep "Music")
PICS=$(df | grep "Pictures")
PR0N=$(df | grep "pr0n")
VIDEO=$(df | grep "Video")

allmounted=true

#testing drive (doesn't exist)
#if [ -z "${TEST}" ];
#then
#    echo "test drive not mounted"
#    allmounted=false
#else
#    echo "test drive mounted"
#fi

#backup drive:
if [ -z "${BACKUP}" ];
then
    echo "Backup drive not mounted"
    allmounted=false
else
    echo "Backup drive mounted"
fi

#Docs:
if [ -z "${DOCS}" ];
then
    echo "Documents drive not mounted"
    allmounted=false
else
    echo "Documents drive mounted"
fi

#Hegre:
if [ -z "${HEGRE}" ];
then
    echo "Hegre drive not mounted"
    allmounted=false
else
    echo "Hegre drive mounted"
fi

#Music:
if [ -z "${MUSIC}" ];
then
    echo "Music drive not mounted"
    allmounted=false
else
    echo "Music drive mounted"
fi

#Pics:
if [ -z "${PICS}" ];
then
    echo "Pictures drive not mounted"
    allmounted=false
else
    echo "Pictures drive mounted"
fi

#Porn:
if [ -z "${PR0N}" ];
then
    echo "pr0n drive not mounted"
    allmounted=false
else
    echo "pr0n drive mounted"
fi

#Video:
if [ -z "${VIDEO}" ];
then
    echo "Video drive not mounted"
    allmounted=false
else
    echo "Video drive mounted"
fi

#check our boolean:
if [ "$allmounted" = true ];
then
    echo "all drives are mounted"
else
    echo "1 or more drives are not mounted"
    exit 1
fi

