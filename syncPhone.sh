#!/bin/bash

rsync --progress --archive --update --delete --ignore-existing $HOME/Music/ /media/3336-6231/Music/
