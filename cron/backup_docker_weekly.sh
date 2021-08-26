#!/bin/bash
# archive the /docker backup weekly

HOST=$(/usr/bin/hostname)
SRC="/mnt/mobius/Backup/docker/${HOST}"
DEST="/mnt/mobius/Backup/docker/archive/${HOST}/"

# the following assumes that if $DEST exists, $SRC must also exist
if [ -e "${DEST}/" ]
then
    # remove the oldest archive
    OLD_ARCH=$(ls -1q "${DEST}/" | head -1)
    rm "${DEST}/${OLD_ARCH}"

    # create new archive
    DATE=$(date +%F-%T)
    FULL_DEST="${DEST}/${HOST}_docker.${DATE}.pigz.tar.gz"
    /usr/bin/tar -cf "${FULL_DEST}" --use-compress-prog=pigz "${SRC}/"
fi


