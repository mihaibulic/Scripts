#!/bin/bash
set -e

APT_GET_INSTALL="sudo apt-get install -y -q"
APT_GET_PURGE="sudo apt-get purge"

echo "**********Updating apt-get"
sudo apt-get update

echo "**********Installing basic tools"
$APT_GET_INSTALL google-chrome-stable eclipse emacs vim ssh subversion git-core gitk traceroute units octave3.2 imagemagick cvs denyhosts smartmontools nmap netcat wireshark ffmpeg mplayer vlc olsrd sysstat libraw1394-dev autopoint valgrind google-talkplugin

echo "**********Installing C/Python"
$APT_GET_INSTALL ant autoconf automake autotools-dev libglib2.0-dev manpages-dev libgl1-mesa-dev  libfwbase1-dev gtk-doc-tools libgtk2.0-dev python-dev libusb-dev libfuse-dev libncurses-dev libusb-1.0-0-dev manpages-posix-dev

echo "**********Installing java"
$APT_GET_INSTALL openjdk-6-jdk libjogl-java libjogl-jni libjzlib-java 

echo "**********Installing LAMP"
$APT_GET_INSTALL apache2 php5 libapache2-mod-php5 mysql-server libapache2-mod-auth-mysql php5-mysqlnd phpmyadmin 

echo "**********Installing JSP"
$APT_GET_INSTALL tomcat6 tomcat6-common libtomcat6-java libcommons-pool-java libcommons-dbcp-java authbind tomcat6-admin tomcat6-examples

echo "**********Speeding up system"
$APT_GET_INSTALL preload
$APT_GET_PURGE brltty foo2zjs gwibber gwibber-service hplip hplip-data hpijs min12xxw pxljr splix ttf-indic-fonts-core ttf-punjabi-fonts

echo "**********Clean up"
sudo apt-get autoremove

echo "**********Rebooting"
sleep 2
sudo reboot

