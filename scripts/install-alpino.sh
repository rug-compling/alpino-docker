#!/bin/bash

PATH=/sp/bin:/go/bin:$PATH
export LANG=en_US.utf8
export LANGUAGE=en_US.utf8
export LC_ALL=en_US.utf8

git lfs install

cd /alpino

if [ ! -d Alpino/.git ]
then
    rm -fr Alpino
    git clone --depth=1 https://github.com/rug-compling/Alpino
fi

cd Alpino
git pull

if [ ! -f ../master ]
then
    touch ../master
fi

if diff -q ../master .git/refs/heads/master
then
    echo geen veranderingen
    exit 0
fi

make realclean

export ALPINO_HOME=`pwd`
echo '#!/bin/sh' > bin/Alpino
chmod +x bin/Alpino
. create_bin/env.sh
make
rm bin/Alpino
make install

mkdir create_bin/extralibs
cp -d /usr/lib/x86_64-linux-gnu/libboost_filesystem.so* create_bin/extralibs
cp -d /usr/lib/x86_64-linux-gnu/libboost_system.so* create_bin/extralibs
cp -d /usr/lib/x86_64-linux-gnu/libtcl*.so* create_bin/extralibs
cp -d /usr/lib/x86_64-linux-gnu/libtk*.so* create_bin/extralibs
cp -R /usr/share/tcltk/* create_bin/extralibs

make -f Makefile.export

cp .git/refs/heads/master ..

