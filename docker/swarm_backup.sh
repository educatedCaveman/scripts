#!/bin/bash
# base variables
ENV=""                  # to be set after checking first arg
SRC="/mnt/gluster/"
DEST=""                 # to be set after checking first and 2nd arg

# check number of args
if [ "$#" -ne 2 ]
then
    echo "script requires an argument"
    exit 1
fi

# check first arg
if [ "$1" == "DEV" ]
then
    ENV="$1"
elif [ "$1" == "PRD" ]
then
    ENV="$1"
else
    echo "illegal argument #1. must be in ('PRD', 'DEV')."
    exit 1
fi

# check second arg
if [ "$2" == "manager" ]
then
    DEST="/mnt/mobius/Backup/docker/portainer/${ENV}/"
elif [ "$2" == "worker" ]
then
    DEST="/mnt/mobius/Backup/docker/data/${ENV}/"
else
    echo "illegal argument #2. must be in ('manger', 'worker')."
    exit 1
fi

#check for empty source; if empty, do nothing
if [ "$(find ${SRC} -mindepth 1 | read)" ]
then
    echo "backup source empty. skipping backup"
else
    echo "backing up..."
    # run the backup
    /usr/bin/rsync -az --delete "${SRC}" "${DEST}"
fi
