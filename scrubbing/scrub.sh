###############################################################################
# script to calculate the checksums of every file in $ROOT and below into the #
# $FILE file                                                                  #
#                                                                             #
# 1.)  move the old versions of the files down                                #
# 2.)  crate the new checksum file                                            #
# 3.)  compare the 0th and the 1st version for differences                    #
#      a.)  collect file list of mismatching checksums.  This list represents #
#           corrupted or modified files.                                      #
#      b.)  collect file list of new files.  These files appreared in the 0th #
#           version but not the 1st. version.                                 #
#      c.)  collect file list of missing files.  Thess files appeared in the  #
#           1st version but not the 0th.                                      #
# 4.)  E-mail the lists to myself.  may not be possible...                    #
###############################################################################

#variables:
CHECKSUM_BASE="/home/drake/scripts/scrubbing/checksums"
NEW_CHECKSUMS="/home/drake/scripts/scrubbing/checksums0.txt"
OLD_CHECKSUMS="/home/drake/scripts/scrubbing/checksums1.txt"
COMPARE="/home/drake/scripts/scrubbing/compare.txt"
ROOT="/home/drake/Dropbox/"	#the directory to be checked
RESULT="/home/drake/scripts/scrubbing/scrubbing_results.txt"

#mv files down:
rm "$CHECKSUM_BASE"8.txt
mv "$CHECKSUM_BASE"7.txt "$CHECKSUM_BASE"8.txt
mv "$CHECKSUM_BASE"6.txt "$CHECKSUM_BASE"7.txt
mv "$CHECKSUM_BASE"5.txt "$CHECKSUM_BASE"6.txt
mv "$CHECKSUM_BASE"4.txt "$CHECKSUM_BASE"5.txt
mv "$CHECKSUM_BASE"3.txt "$CHECKSUM_BASE"4.txt
mv "$CHECKSUM_BASE"2.txt "$CHECKSUM_BASE"3.txt
mv "$CHECKSUM_BASE"1.txt "$CHECKSUM_BASE"2.txt
mv "$CHECKSUM_BASE"0.txt "$CHECKSUM_BASE"1.txt

#create new checksum file:

#create new checksum file with timestamp, filenames, and checksums
date > $NEW_CHECKSUMS
echo "calculating checksums..."
find "$ROOT" -type f -name "*" | while read -r line; do
	shasum "$line" >> "$NEW_CHECKSUMS"
done

#compare new and old:
echo "comparing checksums..."
shasum -c "$OLD_CHECKSUMS" > "$COMPARE"

###################################
# Output for the collected file:  #
###################################

#unsert timestamp:
date > "$RESULT"
echo "" >> "$RESULT"

#failed files:
echo "writing corrupted/modified files..."
echo "##############################" >> "$RESULT"
echo "# corrupted/modified files:  #" >> "$RESULT"
echo "##############################" >> "$RESULT"
echo "" >> "$RESULT"
cat "$COMPARE" | grep FAILED | while read -r line; do
	echo "$line" >> "$RESULT"
done
echo "" >> "$RESULT"

#attempted combo
echo "writing differing checksums..."
echo "#######################" >> "$RESULT"
echo "# checksum compares:  #" >> "$RESULT"
echo "#######################" >> "$RESULT"
echo "" >> "$RESULT"
echo "a file listed here has changed since the last run.  If you did not make this change, the file is likely corrupt" >> "$RESULT"
echo "" >> "$RESULT"
cat "$COMPARE" | grep FAILED | cut -d : -f 1 | while read -r line; do
	#print file name:
	echo "$line:" >> "$RESULT"
	echo "" >> "$RESULT"
	#print old checksum
	echo -e "\t$(cat "$OLD_CHECKSUMS" | grep "$line" | cut -d \  -f 1)" >> "$RESULT"
	#print new checksum
	echo -e "\t$(cat "$NEW_CHECKSUMS" | grep "$line" | cut -d \  -f 1)" >> "$RESULT"
	echo "" >> "$RESULT"
done

#get differences
echo "writing added/removed files..."
echo "#########################" >> "$RESULT"
echo "# added/removed files:  #" >> "$RESULT"
echo "#########################" >> "$RESULT"
echo "" >> "$RESULT"
echo "any corrupted/edited files will appear here, as well as above in the previous section" >> "$RESULT"
echo "" >> "$RESULT"
echo "$(diff "$OLD_CHECKSUMS" "$NEW_CHECKSUMS" >> "$RESULT")"

#email differences and bad rows
#might not be possible?

