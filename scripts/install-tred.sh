#!/bin/bash

set -e

if [ -f /opt/tred/ok ]
then
    echo TrEd is al geïnstalleerd
    exit 0
fi

PATH=/opt/bin:$PATH

cd /opt
tar vxzf /src/tred-current.tar.gz
cd /
patch -p0 < /src/tred.diff

tar vxzf /src/tred-dep-unix.tar.gz
cd packages_unix
./install

touch /opt/tred/ok
