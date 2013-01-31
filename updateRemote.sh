#!/bin/bash
# sends various files from this computer to the public-comp (hostname)

mkdir -p /tmp/updateDir

cp $HOME/personal/java/personal.jar /tmp/updateDir
cp $HOME/jarvis/java/jarvis.jar /tmp/updateDir

cp $HOME/april/java/april.jar /tmp/updateDir
cp $HOME/magic/java/magic.jar /tmp/updateDir
cp $HOME/uorc/user/java/orc.jar /tmp/updateDir

cp $HOME/lcm-read-only/lcm-java/lcm.jar /tmp/updateDir
sudo cp /usr/share/java/jaudiotagger-2.0.3.jar /tmp/updateDir
sudo cp /usr/local/share/java/lcm.jar /tmp/updateDir
sudo cp /usr/share/java/jogl.jar /tmp/updateDir
sudo cp /usr/share/java/jzlib.jar /tmp/updateDir
sudo cp /usr/share/java/gluegen-rt.jar /tmp/updateDir
sudo cp /usr/local/xuggler/share/java/jars/xuggle-xuggler.jar /tmp/updateDir

#cp $HOME/personal/artists /tmp/updateDir
#cp $HOME/personal/genres /tmp/updateDir

cp $HOME/scripts/central_sync.sh /tmp/updateDir
cp $HOME/scripts/sync.sh /tmp/updateDir
cp $HOME/scripts/central-sync.conf /tmp/updateDir
#cp $HOME/scripts/echonest.sh /tmp/updateDir
#cp $HOME/scripts/dedup.py /tmp/updateDir

scp -r /tmp/updateDir mihai@public-comp:~/

ssh mihai@public-comp 'sudo mv updateDir/*.jar /usr/share/java/.; sudo mv updateDir/*.conf /etc/init/.; mv updateDir/* .; rm -rf updateDir'

sudo rm -rf /tmp/updateDir
