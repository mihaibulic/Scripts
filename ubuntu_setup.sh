#/bin/sh
set -e

# INSTALL #
# INSTALL PREP (/etc/apt/sources.list) #
sudo echo ‘deb http://repository.spotify.com stable non-free’ >> /etc/apt/sources.list
sudo echo ‘deb http://dl.google.com/linux/deb/ stable main’ >> /etc/apt/sources.list
sudo echo ‘deb http://dl.google.com/linux/talkplugin/deb/ stable main’ >> /etc/apt/sources.list
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59
sudo apt-get update

# QUICK INSTALLS #
sudo apt-get -y -q install vim git

# IMPORTANT INSTALLS #
sudo apt-get -y -q install ssh maven subversion mysql-server sqlite eclipse openjdk-7-jdk libjogl-java libjogl-jni libjzlib-java gitk valgrind tomcat7 ant r-base 

# PROGRAMS AND STUFF #
sudo apt-get -y -q install google-chrome-stable google-talkplugin gimp imagemagick spotify-client-qt vlc gstreamer0.10-ffmpeg gstreamer0.10-fluendo-mp3 gstreamer0.10-plugins-bad gstreamer0.10-plugins-ugly flashplugin-installer ffmpeg mplayer 

# RANDOM INSTALLS #
sudo apt-get -y -q install traceroute denyhosts nmap netcat wireshark sysstat autopoint autoconf automake autotools-dev libglib2.0-dev manpages-dev libgl1-mesa-dev gtk-doc-tools libgtk2.0-dev python-dev libusb-dev libfuse-dev libncurses-dev libusb-1.0-0-dev manpages-posix-dev lib32ncurses5

# CODE #
cd $HOME
git clone http://github.com/Scripts.git
mkdir -p $HOME/Workspaces
cp -r Scripts/cfg/jars $HOME/Workspaces/.
cp Scripts/cfg/bashrc $HOME/.bashrc
source $HOME/.bashrc

cd $HOME/Workspaces
svn checkout http://lcm.googlecode.com/svn/trunk lcm
cd lcm
./bootstrap.sh
./configure
make
sudo make install

cd $HOME/Workspaces
svn checkout https://libdc1394.svn.sourceforge.net/svnroot/libdc1394/trunk/libdc1394/
cd libdc1394
autoreconf -i -s
./configure
make
sudo make install

cd $HOME/Workspaces
git clone git://april.eecs.umich.edu/home/git/april.git
git clone http://github/mihaibulic/april.git myapril
git clone http://github/mihaibulic/audiomaster.git
git clone http://github/mihaibulic/dibmap.git
git clone http://github/mihaibulic/jarvis.git
git clone http://github/mihaibulic/lcm.git
git clone http://github/mihaibulic/madmin.git
git clone http://github/mihaibulic/misquares.git
git clone http://github/mihaibulic/music.git
git clone http://github/mihaibulic/personal.git
git clone http://github/mihaibulic/ramit.git
git clone http://github/mihaibulic/TabMaster.git
svn checkout <>

cd $HOME/Workspaces/april/java && mkdir -p build && ant
cd $HOME/Workspaces/audiomaster && mkdir -p build && ant
cd $HOME/Workspaces/jarvis/java && mkdir -p build && ant
cd $HOME/Workspaces/personal/java && mkdir -p build && ant
cd $HOME/Workspaces/music/java && mkdir -p build && ant
cd $HOME/Workspaces/justastat && mvn clean install
cd $HOME

# SCRIPT #
sudo apt-get -y -q install preload
sudo apt-get -y -q purge brltty brltty-x11 gwibber gwibber-service empathy empathy-common rhythmbox rhythmbox-date
