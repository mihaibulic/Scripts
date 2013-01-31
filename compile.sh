#!/bin/bash
# compiles all java directories

cd $HOME/april/java && ant clean && ant
cd $HOME/uorc/user/java && ant clean && ant
cd $HOME/magic/java && ant clean && ant
cd $HOME/jarvis/java && mkdir -p build && ant clean && ant
cd $HOME/personal/java && mkdir -p build && ant clean && ant
