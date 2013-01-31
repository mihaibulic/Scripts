#!/bin/bash

if [ $# -ne 2 ]; then
    echo "run with these args: <dir of music> <location of output artist file>"
    exit -1
fi

ls $1 > tmp1
cat tmp1 | sed s/"; "/\\n/g | sed s/";"/\\n/g | sed s/"  "/" "/g | sed s/"^ "/""/g | sed s/,.*$/""/g | sed s/" - ".*$/""/g > tmp2

java personal.util.Sort $(pwd)"/tmp2" $2

rm tmp1 tmp2

