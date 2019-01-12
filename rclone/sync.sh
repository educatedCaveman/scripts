#!/bin/bash
#rclone backup command:
/usr/bin/rclone --drive-use-trash=false --transfers=32 --drive-chunk-size=32768 --bwlimit 8M --skip-links --log-file=/home/drake/logs/rclone.$(date +%F).log --log-level=NOTICE sync /mnt/mobius black-mirror:/ 2>&1
