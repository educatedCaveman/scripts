#!/bin/bash
BACKUP_DIR=/mnt/mobius/Backup/pihole

if [ -d "$BACKUP_DIR" ]; then
    cd $BACKUP_DIR
    pihole -a -t
fi
#TODO: slack notification if backup fails