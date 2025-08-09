#!/bin/bash
set -e
unset CDPATH
script="$(readlink -f "$0")"
cd "$(dirname "$script")"

c=""
if [ -f NOCACHE ]
then
    c="--no-cache"
fi

docker build $c -t localhost/alpino-devel:latest .
rm -f NOCACHE
