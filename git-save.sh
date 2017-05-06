#!/bin/bash
#script to add, commit, and push git chnages
#need to consider working directory?

#git:
echo "adding all files to git..."
git add *
echo "done!"
read -p "enter commit message:  " cm
echo "committing..."
git commit -m "$cm"
echo "done!"
echo "pushing changes to GitHub..."
git push origin master
echo "done!"
