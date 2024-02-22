#!/bin/bash

set -e

PATH=/go/bin:$PATH

######## AppImage tools

cd /tools

if [ ! -d linuxdeploy/squashfs-root ]
then
    rm -fr linuxdeploy
    mkdir linuxdeploy
    cd linuxdeploy
    /src/linuxdeploy --appimage-extract
fi

cd /tools

if [ ! -d appimagetool/squashfs-root ]
then
    rm -fr appimagetool
    mkdir appimagetool
    cd appimagetool
    /src/appimagetool --appimage-extract
fi

######## alto

cd /tools

if [ ! -d alto/.git ]
then
    rm -fr alto
    git clone --depth=1 https://github.com/rug-compling/alto
fi

cd alto
git pull

if [ ! -f ../master-alto ]
then
    touch ../master-alto
fi

if diff -q ../master-alto .git/refs/heads/master
then
    echo geen veranderingen in alto
else
    make -f /src/Makefile.alto
    cp .git/refs/heads/master ../master-alto
fi

######## alud

cd /tools

if [ ! -d alud/.git ]
then
    rm -fr alud
    git clone --depth=1 https://github.com/rug-compling/alud
fi

cd alud
git pull

if [ ! -f ../master-alud ]
then
    touch ../master-alud
fi

if diff -q ../master-alud .git/refs/heads/master
then
    echo geen veranderingen in alud
else
    cd v2/cmd/alud-dact
    CGO_CFLAGS=-I/opt/dbxml2/include \
        CGO_CXXFLAGS=-I/opt/dbxml2/include \
        CGO_LDFLAGS='-L/opt/dbxml2/lib -Wl,-rpath=/opt/dbxml2/lib' \
        go build -o /opt/bin/alud .
    CGO_CFLAGS=-I/opt/dbxml6/include \
        CGO_CXXFLAGS=-I/opt/dbxml6/include \
        CGO_LDFLAGS='-L/opt/dbxml6/lib -Wl,-rpath=/opt/dbxml6/lib' \
        go build -o /opt/bin/alud_v6 .
    cd /tools/alud
    cp .git/refs/heads/master ../master-alud
fi

######## alpinoviewer

cd /tools

if [ ! -d alpinoviewer/.git ]
then
    rm -fr alpinoviewer
    git clone --depth=1 https://github.com/rug-compling/alpinoviewer
fi

cd alpinoviewer
git pull

if [ ! -f ../master-alpinoviewer ]
then
    touch ../master-alpinoviewer
fi

if diff -q ../master-alpinoviewer .git/refs/heads/master
then
    echo geen veranderingen in alpinoviewer
else
    CGO_CFLAGS=-I/opt/dbxml6/include \
        CGO_CXXFLAGS=-I/opt/dbxml6/include \
        CGO_LDFLAGS='-L/opt/dbxml6/lib -Wl,-rpath=/opt/dbxml6/lib' \
        go build -o /opt/lib/alpinoviewer.bin .
    make -C shm
    mv shm/XlibNoSHM.so /opt/lib
    cp .git/refs/heads/master ../master-alpinoviewer
fi
