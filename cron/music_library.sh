#!/bin/bash
LOCK="/tmp/music_library.lock"
LIBRARY="/mnt/mobius/Music/library"
MOBILE="/mnt/mobius/Music/mobile"
FLACS="/tmp/flac_list.txt"
TO_CONVERT="/tmp/flacs_to_convert.txt"
#TODO: slack notifications?
            
# first, check if process is running. if it is, exit
if [ -f "${LOCK}" ]
then
    echo "process already running"
    exit
fi

# if it isn't, create the lockfile
touch "${LOCK}"

# remove the flac file, if it exists
if [ -f "${FLACS}" ]
then
    rm "${FLACS}"
fi

# remove the flac file, if it exists
if [ -f "${TO_CONVERT}" ]
then
    rm "${TO_CONVERT}"
fi


# remove unwanted file types in library:
junk=("*.to" "*.txt" "*.log" "*.jpg" "*.jpeg" "*.JPG" "*.JPEG" "*.png" "*.PNG" "*.m3u" "*.cue" "*.nfo")
for type in "${junk[@]}"
do
    find "${LIBRARY}/" -type f -name "${type}" -delete 
done

# sync non-flac files to mobile library, and handle deleted files
rsync -az "${LIBRARY}/" "${MOBILE}/" --exclude="*.flac" --delete

# determine .flac files requiring conversion
# flac files
find "${LIBRARY}/" -type f -name "*.flac" | sort > "${FLACS}"
sed -i 's/\.flac$//' "${FLACS}"       # remove .flac extension
sed -i "s,${LIBRARY}/,," "${FLACS}"    # remove leading path, and use different delimiter

while read LINE
do
    FLAC_FILE="${LIBRARY}/${LINE}.flac"
    OGG_FILE="${MOBILE}/${LINE}.ogg"

    if [ ! -f "${OGG_FILE}" ]
    then
        echo "${LINE}" >> "${TO_CONVERT}"
    fi

done < "${FLACS}"

# convert the files
parallel -a "${TO_CONVERT}" ffmpeg -nostdin -loglevel quiet -i "${LIBRARY}/{}.flac" -c:a libvorbis -q:a 8 "${MOBILE}/{}.ogg"

# cleanup
rm "${FLACS}"
rm "${TO_CONVERT}"
rm "${LOCK}"

