#!/bin/bash

#backup pihole config
cd /mnt/mobius/Backup/pihole
/usr/local/bin/pihole -a -t

# notification:
sh $HOME/scripts/slack/pihole_backup.py