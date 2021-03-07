#!/bin/bash
# base variables
SRC="/var/lib/plexmediaserver/Library/Application Support/Plex Media Server"
DEST="/mnt/mobius/Backup/plex"
CACHE="${SRC}/Cache*"

#check for empty source; if empty, do nothing
if [ "$(find ${SRC} -mindepth 1 | read)" ]
then
    echo "backup source empty. skipping backup"
else
    echo "backing up..."
    # run the backup
    /usr/bin/rsync -az --delete --exclude="${CACHE}" "${SRC}" "${DEST}"
fi
