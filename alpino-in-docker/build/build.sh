#!/bin/bash
set -e
unset CDPATH
script="$(readlink -f "$0")"
cd "$(dirname "$script")"

docker build -t registry.webhosting.rug.nl/compling/alpino:latest .
