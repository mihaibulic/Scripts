#!/bin/bash
#set up laptop for development

CFG=$(pwd)
APT_GET_INSTALL="sudo apt-get install -y -q"
TARGET=/var/tmp

if [ -e $TARGET/libdc1394 ]; then
    cd $TARGET/libdc1394/libdc1394
    git pull
else
    cd $TARGET
    git clone git://libdc1394.git.sourceforge.net/gitroot/libdc1394/libdc1394 
    cd $TARGET/libdc1394/libdc1394
fi

if [ ! -e $TARGET/libdc1394/libdc1394/Makefile ]; then
    autoreconf -i -s
    $TARGET/libdc1394/libdc1394/configure
fi
make -s
sudo make -s install
