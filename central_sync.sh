#!/bin/bash
# Will attempt to rsync from all sources
# This will run rsync operations on multiple remotes in parrallel practically as soon as they become available
#
# To add new remotes:
#   1. Add their name to PERSON
#   2. Add to COMP: //HOSTNAME/SHARE-NAME (SHARE-NAME is the name of the folder you shared usually)  
#   3. Add any additional directories to cd through to remote, or leave blank if none

if [ "$(pgrep central_sync.sh)" != $$ ]; then #locks the script so only 1 instance can run
    exit
fi

PERSON=( "Lyndsay" "Ali" "Andrew" "Tony" "Mihai" )
COMP=( "//LYNDSAYS-MAC/Music" "//ALI-MAC/Music" "//ANDREW-PC/Music" "//TONY-PC/Users" "//DESKHAI/backup" )
REMOTE=( "" "" "" "Tony/Music/" "Music/" )
DEST=/mnt/ExtHai/media/Music/

sudo killall -w -9 sync.sh

for ((i=0;i<${#COMP[@]};i++));
do 
    rm -f "/tmp/${PERSON[$i]}"
    echo "Sync: Starting daemon for ${PERSON[$i]}."
    MNT="/mnt/${PERSON[$i]}/"
    ./sync.sh "${PERSON[$i]}" "${COMP[$i]}" "${MNT}" "${MNT}${REMOTE[$i]}" "${DEST}${PERSON[$i]}" &
done

exit

