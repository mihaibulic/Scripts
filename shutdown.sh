#!/bin/bash
# script to avoid slowdowns (network manager) and hang ups (shutdown -P instead of halt) on shutdowns

sudo service network-manager stop
sudo killall -9 -w NetworkManager
sudo shutdown -P now
