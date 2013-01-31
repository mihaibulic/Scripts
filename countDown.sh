#!/bin/bash

if [ $# -eq 2 ]; then
    msg=$2
else
    msg="DONE"
fi  

sleep $1
notify-send -t 3 "$msg"

