#!/bin/bash

#backup pihole config
cd /mnt/mobius/Backup/pihole
/usr/local/bin/pihole -a -t

# notification:
/usr/bin/python3 /home/drake/scripts/slack/pihole_backup.py