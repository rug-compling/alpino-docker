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
<<<<<<< HEAD
docker build $c -t registry.webhosting.rug.nl/compling/alpino-16:latest .
=======
docker build $c -t registry.webhosting.rug.nl/compling/alpino-22:latest .
>>>>>>> 22.04
rm -f NOCACHE
