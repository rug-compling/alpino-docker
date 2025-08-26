#!/bin/bash

set -e
unset CDPATH
script="$(readlink -f "$0")"
cd "$(dirname "$script")"

set -x
<<<<<<< HEAD
docker push registry.webhosting.rug.nl/compling/alpino-16:latest
=======
docker push registry.webhosting.rug.nl/compling/alpino-22:latest
>>>>>>> 22.04
