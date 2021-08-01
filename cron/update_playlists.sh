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

# cd ${WATCH_DIR}
FILES="${WATCH_DIR}/*.m3u"
for playlist in $FILES
do
    if [ -e "$playlist" ]
    then
        # sanitization:
        sed -i "s,${PREFIX}/,," "${playlist}"
        sed -i 's/\.flac$/\.ogg/' "${playlist}"

        # move the sanitized playlist to the mobile library
        # overwrite the old playlist, if it exists.  create it if it doesn't
        mv -f "${playlist}" "${MOBILE}/"
    fi
done

# remove lock file and any other tmp files
rm "${LOCK}"

