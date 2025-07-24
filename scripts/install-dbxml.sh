#!/bin/bash

set -e

cd /dbxml
if [ ! -d dbxml2/.git ]
then
    rm -fr dbxml2
    git clone --depth=1 https://github.com/rug-compling/dbxml dbxml2
fi

git config --global --add safe.directory /dbxml/dbxml2

cd dbxml2
git pull

if [ ! -f ../master2 ]
then
    touch ../master2
fi

if diff -q ../master2 .git/refs/heads/master
then
    echo geen veranderingen in DbXML 2
else
    ./buildall.sh --prefix=/opt/dbxml2
    cp .git/refs/heads/master ../master2
fi

cd /dbxml
if [ -f done6 ]
then
    echo DbXML 6 is al geïnstalleerd
    exit 0
fi

rm -fr dbxml6 dbxml-6.1.4
tar vxzf /src/dbxml-6.1.4.tar.gz --no-same-owner
patch -p0 < /src/dbxml-6.1.4-patch_26647.diff
mv dbxml-6.1.4 dbxml6
cd dbxml6
./buildall.sh --prefix=/opt/dbxml6 --with-configure-env="CXXFLAGS=-std=c++03 LDFLAGS=-Wl,-rpath=/opt/dbxml6"
touch ../done6

