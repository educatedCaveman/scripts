#!/bin/bash
# create playlists for PC based on the mobile ones
# to be used when re-creating the music ratings

LOCAL_PATH="/media/storage/Music/"
SOURCE_DIR=$HOME
WORK_DIR="/tmp"
M3U_DIRECTIVES=("#EXTM3U" "#EXTINF")

# prep; clean out /tmp
rm /tmp/*.m3u

OIFS="$IFS"
IFS=$'\n'
for FILE in `find ${SOURCE_DIR} -name "*.m3u"`
do 
    PLAYLIST=$(basename "${FILE}")
    # echo $PLAYLIST
    # PLAYLIST="5 stars.m3u"
    TMPFILE="/tmp/${PLAYLIST}"

    # handle the m3u directives
    for DIRECTIVE in "${M3U_DIRECTIVES[@]}"
    do
        # echo $DIRECTIVE
        awk -v local_path="${LOCAL_PATH}" '{print local_path $0}' "${PLAYLIST}" > "${TMPFILE}"
        bad_prefix="${LOCAL_PATH}${DIRECTIVE}"
        sed -i "s|$bad_prefix|${DIRECTIVE}|g" "${TMPFILE}"
    done

    # replace .ogg with .flac
    sed -i 's/\.ogg$/\.flac/' "${TMPFILE}"

done







# head -20 /tmp/5\ stars.m3u