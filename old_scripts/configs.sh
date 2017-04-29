#!/bin/bash
#/home/drake/scripts/configs.sh

#sync the config directories with the backup directories (daily)

#sync /etc/
rysnc -aqz /etc/ /media/storage/backup/etc/ &

#sync /home/
rsync -aqz /home/ /media/storage/backup//home/ &
