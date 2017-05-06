#!/bin/bash
#script to add, commit, and push git chnages
#need to consider working directory?

#test:
#read -p "enter message: " cm
#echo "your message was: $cm"

#git:
git add *
read -p "enter commit message: " cm
git commit -m "$cm"
git push origin master
