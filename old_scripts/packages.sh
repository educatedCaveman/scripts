#!/bin/bash
#/home/drake/scripts/packages.sh

# list all installed packages, and back them up weekly (separate script)

# cycle the files down the list (locol only)
/bin/mv /media/storage/backup/packages/packages.0.txt /media/storage/backup/packages.1.txt.$(date +%Y-%m-%d)
/bin/mv /media/storage/backup/packages/packages.1.txt /media/storage/backup/packages.2.txt.$(date +%Y-%m-%d)
/bin/mv /media/storage/backup/packages/packages.2.txt /media/storage/backup/packages.3.txt.$(date +%Y-%m-%d)
/bin/mv /media/storage/backup/packages/packages.3.txt /media/storage/backup/packages.4.txt.$(date +%Y-%m-%d)
/bin/mv /media/storage/backup/packages/packages.4.txt /media/storage/backup/packages.5.txt.$(date +%Y-%m-%d)
/bin/mv /media/storage/backup/packages/packages.5.txt /media/storage/backup/packages.6.txt.$(date +%Y-%m-%d)
/bin/mv /media/storage/backup/packages/packages.6.txt /media/storage/backup/packages.7.txt.$(date +%Y-%m-%d)

#create the new versions.  (dropbox and local)
/usr/bin/dpkg-query -l > /media/storage/backup/packages/packages.0.txt
/usr/bin/dpkg-query -l > /home/drake/Dropbox/maintenance_scripts/txt_files/packages.txt
