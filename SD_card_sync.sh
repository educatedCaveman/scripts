#!/bin/bash
#template for commands to sync music and playlists from local library to SD card

#clean up playlists:
sed -i -e 's/\/media\/storage\///g' /media/storage/Music/*.m3u

#rsync:
rsync -avz --progress --delete /media/storage/Music/ /run/media/drake/2E02-6826/Music
