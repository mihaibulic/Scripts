#!/bin/bash
# starts echonest, which is a DB server for music fingerprints

sleep 10

sudo killall -w java
sudo ttservctl stop
sudo ttservctl start
cd $HOME/echoprint-server/solr/solr
java -Dsolr.solr.home=/home/mihai/echoprint-server/solr/solr/solr/ -Djava.awt.headless=true -jar start.jar &

