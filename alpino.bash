#!/bin/bash

if [ $# != 1 ]
then
    echo Usage: $0 workdir
    exit
fi

if [ ! -d $1 ]
then
    echo $1 is not a directory
    exir
fi

docker run \
       --net=host \
       --user=`id -u`:`id -g` \
       --rm \
       -i -t \
       -e DISPLAY \
       -v $1:/work \
       rugcompling/alpino:latest
