#!/bin/bash
LOCK="/tmp/playlist.lock"
WATCH_DIR='/media/storage/convert_playlist'
MOBILE="/media/storage/Music_(mobile)"
PREFIX="/media/storage/Music"

# check for lockfile. if present exit
if [ -f "${LOCK}" ]
then
    echo "process already running"
    exit
fi

# if it isn't, create the lockfile
touch "${LOCK}"

for playlist in ${WATCH_DIR}/*.m3u
do
    base=$(basename "${playlist}")

    # sanitization:
    sed -i "s,${PREFIX}/,," "${playlist}"
    sed -i 's/\.flac$/\.ogg/' "${playlist}"

    # if the playlist already exists in the destination, remove it
    if [ -e "${MOBILE}/${base}" ]
    then
        rm "${MOBILE}/${base}"
    fi

    # move the sanitized playlist to the mobile library
    mv "${playlist}" "${MOBILE}"
done

# remove lock file and any other tmp files
rm "${LOCK}"

