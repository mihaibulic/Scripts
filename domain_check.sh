#!/bin/bash

while true;
do
    read text;
    if [ "$text" == "" ]; then exit; fi
    whois "$text.com" | if [ $(grep -c "No match") -eq 1 ]; then echo "$text.com is AVAILABLE"; else echo "$text.com is TAKEN"; fi
done



