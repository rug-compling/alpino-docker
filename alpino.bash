#!/bin/bash

if [ $# != 1 ]
then
    echo Usage: $0 workdir
    exit
fi

if [ ! -d $1 -o ! -r $1 ]
then
    echo $1 is not a readable directory
    exit
fi

docker run \
       --net=host \
       --user=`id -u`:`id -g` \
       --rm \
       -i -t \
       -e DISPLAY \
       -v $1:/work/data \
       rugcompling/alpino:latest
