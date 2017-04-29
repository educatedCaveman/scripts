##########################################################
# script to list all checksums of files in directory and #
# all directories beneath it.                            # 
##########################################################

#variables:
ROOT="/home/drake/scripts/scrubbing/"
FILE="/home/drake/scripts/scrubbing/checksums.txt"

#replace contents of file:
date > $FILE

#add checksums of all files
for file in $(find $ROOT -type f -name "*")
do 
	shasum $file >> $FILE
done
