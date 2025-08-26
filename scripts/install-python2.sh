#!/bin/bash

set -e

if [ -f /opt/python2/ok ]
then
    echo Python2 is al geïnstalleerd
    exit 0
fi

cd /
tar vxzf /src/Python-2.7.18.tgz
cd Python-2.7.18
export LDFLAGS="-Wl,-rpath=/opt/python2/lib"
./configure --prefix=/opt/python2
make
make install
touch /opt/python2/ok
