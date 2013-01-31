#!/bin/bash
# will sync files from COMP (2nd arg) to dest (4th arg)
# will also chown, set permissions, and adjust the gain (mp3 only) on the rsynced files
# run as <name of person> <remote share to sync from (ie //HOSTNAME/SHARE-NAME)> <location to mnt to (ie /mnt/test)> <folders to go thru on mount (ie /Music)> # <Destination to sync to on this machine (ie $HOME/Music)>

PERSON=$1
COMP=$2
MNT=$3
SRC=$4
DEST=$5

if [ -e "/tmp/${PERSON}" ]; then
    exit
fi

trap "rm -f /tmp/${PERSON}" 0 1 2 3 4 6 8 15 20 EXIT
touch /tmp/${PERSON}

while [ true ]
do
    echo "Sync: Looking for ${PERSON[$i]}."
    sudo mkdir -p $MNT 2>> /tmp/garbage.log

    sudo umount $MNT 2>> /tmp/garbage.log
    sudo mount -r -o username=guest,password="",uid=$USER,gid=$USER -t cifs $COMP $MNT 2>> /tmp/garbage.log
    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        if [ ! -z "$(ls ${MNT})" ]; then # mnt is not empty
            echo "Sync: Found ${PERSON}, syncing now at $(date)" | tee -a sync.log
            mkdir -p $DEST
            sudo rsync --archive --update --ignore-existing --delete $SRC $DEST &>> /tmp/garbage.log
            RETVAL=$?
            if [ $RETVAL -eq 0 ]; then
                echo "Sync: Done syncing ${PERSON} at $(date)." | tee -a sync.log #not temp
            else
                echo "Sync: Syncing with ${PERSON} interrupted at $(date)." | tee -a sync.log
            fi
            sudo umount $MNT &>> sync.log

            echo "Sync: Changing permissions for ${PERSON}'s files." | tee -a sync.log
            sudo chown -R $USER:$USER $DEST
            sudo find $DEST -type d -exec chmod 777 {} \;
            sudo find $DEST -type f -exec chmod 666 {} \;

            echo -e "Sync: Done with ${PERSON}.\n" | tee -a sync.log
        else
            echo "Sync: ${PERSON} is blank."
        fi
    else
        echo "Sync: ${PERSON} isn't available."
    fi
    sleep 600
done

exit

