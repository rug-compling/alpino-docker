#!/bin/bash

if [ $# != 1 ]
then
    echo Usage: $0 workdir
    exit
fi

if [ ! -d "$1" -o ! -r "$1" ]
then
    echo "'$1'" is not a readable directory
    exit
fi

case $1 in
    /*)
	;;
    *)
	echo workdir must be an absolute path
	echo "'$1'" is not an absolute path
	exit
	;;
esac

docker run \
       --net=host \
       --user=`id -u`:`id -g` \
       --rm \
       -i -t \
       -e DISPLAY \
       -v "$1":/work/data \
       rugcompling/alpino:latest
