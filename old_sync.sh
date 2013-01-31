#bin/bash
# OUTDATED
# used to sync between this computer and public computer using ethernet or wifi (based on arg).

#find $HOME/Music/ -type f -iname '*.mp3' -print0 | xargs -0 mp3gain -r -k
REMOTE_E=55.55.55.56

if [ "$1" == "-e" ]; then
    echo "-e seen"
    sudo killall -9 -w NetworkManager
    sudo ifconfig eth0 55.55.55.55 netmask 255.255.255.0 up
    rsync --recursive --update --verbose --human-readable --compress --progress --itemize-changes --delete $HOME/Music/ $REMOTE_E:~/Music/
    ssh $REMOTE_E '$HOME/remote_cfg/updateBanshee.sh' 
    sudo NetworkManager
elif [ "$1" == "-w" ]; then 
    echo "-w seen"
    rsync --recursive --update --verbose --human-readable --compress --progress --itemize-changes --delete $HOME/Music/ $REMOTE:~/Music/
    ssh $REMOTE '$HOME/remote_cfg/updateBanshee.sh' 
else
    echo "error, -w or -e flag needed"
fi

