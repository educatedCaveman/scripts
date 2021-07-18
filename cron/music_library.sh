#!/bin/bash
LOCK="/tmp/music_library.lock"
LIBRARY="/mnt/mobius/Music/library/"
MOBILE="/mnt/mobius/Music/mobile/"
LIB_TMP="/tmp/library.txt"
# MOB_TMP="/tmp/mobile.txt"
# TO_CONVERT="/tmp/files_to_convert.txt"
#TODO: slack notifications?
            
# first, check if process is running. if it is, exit
if [ -f "${LOCK}" ]
then
    echo "process already running"
    exit
fi

# if it isn't, create the lockfile
touch "${LOCK}"

# remove any pre-existing tmp files
rm "${LIB_TMP}"
# rm "${MOB_TMP}"
# rm "${TO_CONVERT}"

# remove unwanted file types in library:
junk=("*.to" "*.txt" "*.log" "*.jpg" "*.jpeg" "*.JPG" "*.JPEG" "*.png" "*.PNG" "*.m3u" "*.cue" "*.nfo")
for type in "${junk[@]}"
do
    find "${LIBRARY}/" -type f -name "${type}" -delete 
done

# sync non-flac files to mobile library, and handle deleted files
rsync -az "${LIBRARY}" "${MOBILE}" --exclude="*.flac" --delete

# determine .flac files requiring conversion
# library files
# find "${LIBRARY}" -type f -name "*.flac" > "${LIB_TMP}"
find "${LIBRARY}" -type f -name "*.flac" > "${LIB_TMP}"
sed -i 's/\.flac$//' "${LIB_TMP}"       # remove .flac extension
sed -i "s,${LIBRARY},," "${LIB_TMP}"    # remove leading path, and use different delimiter

# # mobile files
# # find "${MOBILE}" -type f > "${MOB_TMP}" 
# find "${MOBILE}" -type f | sort > "${MOB_TMP}" 
# sed -i 's/\..\{3\}$//' "${MOB_TMP}"     # remove any 3-letter extension
# sed -i "s,${MOBILE},," "${MOB_TMP}"     # remove leading path, and use different delimiter

# compare the files, only keeping the files in library that aren't in mobile
# comm -23 <(sort "${LIB_TMP}") <(sort "${MOB_TMP}") > "${TO_CONVERT}"
# comm -23 "${LIB_TMP}" "${MOB_TMP}" > "${TO_CONVERT}"

# convert the files
# parallel -a "${TO_CONVERT}" ffmpeg -nostdin -loglevel quiet -i "${LIBRARY}{}.flac" -c:a libvorbis -q:a 8 "${MOBILE}{}.ogg"

while read LINE
do
    # echo "$p"
    FLAC_FILE="${LIBRARY}${LINE}.flac"
    OGG_FILE="${MOBILE}${LINE}.ogg"

    if [ ! -f "${OGG_FILE}" ]
    then
        ffmpeg -nostdin -loglevel quiet -i "${FLAC_FILE}" -c:a libvorbis -q:a 8 "${OGG_FILE}"
    fi
done < "${LIB_TMP}"

# cleanup
rm "${LIB_TMP}"
# rm "${MOB_TMP}"
# rm "${TO_CONVERT}"
rm "${LOCK}"
