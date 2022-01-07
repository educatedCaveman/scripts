#!/bin/bash

SCRIPTS_PATH="/home/drake/scripts"

# --name=       "%N"    Torrent name
# --category=   "%L"    Category
# --tags=       "%G"    Tags (separated by comma)
# --cpath=      "%F"    Content path (same as root path for multifile torrent)
# --rpath=      "%R"    Root path (first torrent subdirectory path)
# --spath=      "%D"    Save path
# --num=        "%C"    Number of files
# --size=       "%Z"    Torrent size (bytes)
# --tracker=    "%T"    Current tracker
# --hash=       "%I"    Info hash

# get the webhook
source /home/drake/.zsh_secrets

/usr/bin/python3 ${SCRIPTS_PATH}/cron/qbt_completion.py \
    --name="${1}" \
    --category="${2}" \
    --tags="${3}" \
    --cpath="${4}" \
    --rpath="${5}" \
    --spath="${6}" \
    --num="${7}" \
    --size="${8}" \
    --tracker="${9}" \
    --hash="${10}"
    