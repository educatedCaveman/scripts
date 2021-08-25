#!/bin/bash
# backup the /docker mount daily

host=$(/usr/bin/hostname)
SRC="/docker/"
DEST="/mnt/mobius/Backup/docker/${host}/"

/usr/bin/rsync -au --delete "${SRC}" "${DEST}"



