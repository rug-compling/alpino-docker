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

set -x
docker build $c -t registry.webhosting.rug.nl/compling/alpino:latest .
rm -f NOCACHE
