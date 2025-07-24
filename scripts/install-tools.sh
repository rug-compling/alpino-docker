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

git config --global --add safe.directory /tools/alto

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
    perl -p -e 's/^go.*/go 1.18/' go.mod > go.mod.tmp
    mv go.mod.tmp go.mod
    make -f /src/Makefile.alto
    git restore go.mod
    cp .git/refs/heads/master ../master-alto
fi

######## alpinoviewer

cd /tools

if [ ! -d alpinoviewer/.git ]
then
    rm -fr alpinoviewer
    git clone --depth=1 https://github.com/rug-compling/alpinoviewer
fi

git config --global --add safe.directory /tools/alpinoviewer

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
    perl -p -e 's/^go.*/go 1.18/' go.mod > go.mod.tmp
    mv go.mod.tmp go.mod
    CGO_CFLAGS=-I/opt/dbxml6/include \
        CGO_CXXFLAGS=-I/opt/dbxml6/include \
        CGO_LDFLAGS='-L/opt/dbxml6/lib -Wl,-rpath=/opt/dbxml6/lib' \
        go build -o /opt/lib/alpinoviewer.bin .
    make -C shm
    git restore go.mod
    mv shm/XlibNoSHM.so /opt/lib
    cp .git/refs/heads/master ../master-alpinoviewer
fi
