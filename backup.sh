#!/bin/bash
# 1. Backup documents, music, pictures, and videos from this laptop to deskhai (Dell XPS monitor/computer) via mount+rsync 
#       -OR-
# 2. Backup documents, music, pictures, and videos from this laptop to a local location (could be ext hdd as well) via rsync
#
# To choose between options, either don't pass an arg for opt 1, or pass a location (i.e. /media/ext_hdd/todays_backup/)

LOCAL_DOCS=$HOME"/Documents/"
LOCAL_MUSIC=$HOME"/Music/"
LOCAL_PICS=$HOME"/Pictures/"
LOCAL_VIDS=$HOME"/Videos/"

if [ "$(pgrep backup.sh)" != $$ ]; then #locks the script so only 1 instance can run
    exit
fi

if [ $# -ne 2 ]; then
    echo -e "To backup files run as ${0} <loc> <speed>:";
    echo -e "loc:";
    echo -e "\t<dir> to signify local dir in which to place backups";
    echo -e "\t-b to signify backing up to designated remote backup location (check script for actual location)";
    echo -e "\t-p to signify syncing music with phone";
    echo -e "speed:";
    echo -e "\t-e to sync files that already Exist on the backup location";
    echo -e "\t-i to Ignore syncing files that exist on the backup location";
    exit
fi

if [ "${1}" == "-b" ]; then #remote backup
    NAME=DeskHai
    COMP=//DESKHAI/backup/
    MNT=/mnt/deskhai/

    BACKUP_DOCS=${MNT}"Documents/"
    BACKUP_MUSIC=${MNT}"Music/"
    BACKUP_PICS=${MNT}"Pictures/"
    BACKUP_VIDS=${MNT}"Videos/"

    sudo mkdir -p $MNT
    sudo umount $MNT

    echo "***Connecting to $NAME"
    sudo mount -o username=guest,password="" -t cifs $COMP $MNT
    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        echo "***Successfully connected to $NAME, now backing up"
        
        if [ "${2}" == "-i" ]; then
            sudo rsync --progress --archive --update --ignore-existing --delete "$LOCAL_DOCS" "$BACKUP_DOCS"
            sudo rsync --progress --archive --update --ignore-existing --delete "$LOCAL_MUSIC" "$BACKUP_MUSIC" 
            sudo rsync --progress --archive --update --ignore-existing --delete "$LOCAL_PICS" "$BACKUP_PICS"
            sudo rsync --progress --archive --update --ignore-existing --delete "$LOCAL_VIDS" "$BACKUP_VIDS"
        elif [ "${2}" == "-e" ]; then        
            sudo rsync --progress --archive --update --delete "$LOCAL_DOCS" "$BACKUP_DOCS"
            sudo rsync --progress --archive --update --delete "$LOCAL_MUSIC" "$BACKUP_MUSIC" 
            sudo rsync --progress --archive --update --delete "$LOCAL_PICS" "$BACKUP_PICS"
            sudo rsync --progress --archive --update --delete "$LOCAL_VIDS" "$BACKUP_VIDS"
        else
            echo -e "***Error, 2nd arg must be -e (existing) or -i (ignore existing)";
        fi

        echo "***Done syncing with $NAME"
        sudo umount $MNT
    else
        echo "***Failed to connect to $NAME"
    fi
elif [ $1 == "-p" ]; then #sync with public
    BACKUP_MUSIC="/media/3336-6231/Music/"
    NAME="MiNe (phone)"

    if [ "${2}" == "-i" ]; then
        sudo rsync --progress --archive --ignore-existing --update --delete "$LOCAL_MUSIC" "$BACKUP_MUSIC"
        echo "***Done syncing with $NAME"
    elif [ "${2}" == "-e" ]; then        
        sudo rsync --progress --archive --update --delete "$LOCAL_MUSIC" "$BACKUP_MUSIC"
        echo "***Done syncing with $NAME"
    else
        echo -e "***Error, 2nd arg must be -e (existing) or -i (ignore existing)";
    fi

elif [ -d $1 ]; then #local backup (ie ext hdd)
    BACKUP_DOCS=${1}"/Documents/"
    BACKUP_MUSIC=${1}"/Music/"
    BACKUP_PICS=${1}"/Pictures/"
    BACKUP_VIDS=${1}"/Videos/"

    if [ "${2}" == "-i" ]; then
        sudo rsync --progress --archive --ignore-existing --update --delete "$LOCAL_DOCS" "$BACKUP_DOCS"
        sudo rsync --progress --archive --ignore-existing --update --delete "$LOCAL_MUSIC" "$BACKUP_MUSIC"
        sudo rsync --progress --archive --ignore-existing --update --delete "$LOCAL_PICS" "$BACKUP_PICS"
        sudo rsync --progress --archive --ignore-existing --update --delete "$LOCAL_VIDS" "$BACKUP_VIDS"
    elif [ "${2}" == "-e" ]; then        
        sudo rsync --progress --archive --update --delete "$LOCAL_DOCS" "$BACKUP_DOCS"
        sudo rsync --progress --archive --update --delete "$LOCAL_MUSIC" "$BACKUP_MUSIC"
        sudo rsync --progress --archive --update --delete "$LOCAL_PICS" "$BACKUP_PICS"
        sudo rsync --progress --archive --update --delete "$LOCAL_VIDS" "$BACKUP_VIDS"
    else
        echo -e "***Error, 2nd arg must be -e (existing) or -i (ignore existing)";
    fi

else
    echo -e "unrecognized directory or invalid option"
fi

notify-send -t 5000 "done backup/syncing"

exit
