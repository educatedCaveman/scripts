#!/bin/bash

##############################################
# script to lock the screen, then hibernate. #
##############################################

# they have to be done in that order so that ther isn't a period 
# where the screen is inlocked after booting.

# the lock script.  makes screen look fuzzy
lock &
#wait a few seconds to ensure lock gets done
sleep 10
# pm-hibernate has been exepted from needing admin password
sudo pm-hibernate
