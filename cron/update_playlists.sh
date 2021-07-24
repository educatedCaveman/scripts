#!/bin/bash
LOCK="/tmp/playlist.lock"
WATCH_DIR='/media/Music/convert_playlist'
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

# remove any .m3u files from /tmp
# the current assumption is only .m3u files are relevant for all of this
for file in "/tmp/*.m3u"
do
    if [ -e "${file}" ]
    then
        rm "${file}"
    fi
done

# for each playlist file in watch directory:
#   - copy to /tmp for processing
#   - remove leading path specific to theseus
#   - replace .flac extension with .ogg extension
#   - move to mobile library.  this helps prevent a broken playlist from getting sent
#   - remove the original file

# for testing:
cp /home/drake/5-stars.m3u "${WATCH_DIR}"

for playlist in "${WATCH_DIR}/*.m3u"
do
    base=$(basename ${playlist})
    tmpfile="/tmp/${base}"
    cp "${WATCH_DIR}/${base}" "${tmpfile}"

    # sanitization:
    sed -i "s,${PREFIX}/,," "${tmpfile}"
    sed -i 's/\.flac$/\.ogg/' "${tmpfile}"

    # move the playlist to the mobile library, and remove the source, if successful
    if mv "${tmpfile}" "${MOBILE}"
    then
        rm "${WATCH_DIR}/${base}"
    fi

done

# remove lock file and any other tmp files
rm "${LOCK}"

