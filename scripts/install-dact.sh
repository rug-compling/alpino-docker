#!/bin/bash

set -e

######## meson

cd /dact

if [ ! -f meson/meson.py ]
then
    rm -fr meson meson-0.55.1
    wget https://github.com/mesonbuild/meson/releases/download/0.55.1/meson-0.55.1.tar.gz
    tar vxzf meson-0.55.1.tar.gz --no-same-owner
    mv meson-0.55.1 meson
    rm meson-0.55.1.tar.gz
fi

export PATH=/dact/meson:$PATH

######## ninja

if [ ! -f ninja/ninja ]
then
    rm -fr ninja
    mkdir ninja
    cd ninja
    wget https://github.com/ninja-build/ninja/releases/download/v1.10.2/ninja-linux.zip
    unzip ninja-linux.zip
    chmod +x ninja
    rm ninja-linux.zip
fi

PATH=/dact/ninja:$PATH

######## alpinocorpus

cd /dact

if [ ! -d alpinocorpus/.git ]
then
    rm -fr alpinocorpus
    git clone --depth=1 https://github.com/rug-compling/alpinocorpus
fi

cd alpinocorpus
git pull

if [ ! -f ../master-alpinocorpus ]
then
    touch ../master-alpinocorpus
fi

if diff -q ../master-alpinocorpus .git/refs/heads/master
then
    echo geen veranderingen in alpinocorpus
else
    rm -rf builddir /opt/alpinocorpus2
    mkdir builddir
    meson.py builddir -D dbxml_bundle=/opt/dbxml2 --prefix=/opt/alpinocorpus2
    ninja -C builddir install
    rm -rf builddir

    cp .git/refs/heads/master ../master-alpinocorpus
fi

######## alpinocorpus_v6

cd /dact

if [ ! -d alpinocorpus_v6/.git ]
then
    rm -fr alpinocorpus_v6
    git clone --depth=1 https://github.com/rug-compling/alpinocorpus alpinocorpus_v6
fi

cd alpinocorpus_v6
git pull

if [ ! -f ../master-alpinocorpus_v6 ]
then
    touch ../master-alpinocorpus_v6
fi

if diff -q ../master-alpinocorpus_v6 .git/refs/heads/master
then
    echo geen veranderingen in alpinocorpus_v6
else
    rm -rf builddir /opt/alpinocorpus6
    mkdir builddir
    meson.py builddir -D dbxml_bundle=/opt/dbxml6 --prefix=/opt/alpinocorpus6
    ninja -C builddir install
    rm -rf builddir

    cp .git/refs/heads/master ../master-alpinocorpus_v6
fi

######## dact

cd /dact

if [ ! -d dact/.git ]
then
    rm -fr dact
    git clone -b dbxml-2.5.16 --depth=1 https://github.com/rug-compling/dact
fi

cd dact
git pull

if [ ! -f ../dbxml-2.5.16-dact ]
then
    touch ../dbxml-2.5.16-dact
fi

if diff -q ../dbxml-2.5.16-dact .git/refs/heads/dbxml-2.5.16
then
    echo geen veranderingen in dact
else
    cmake \
        -DALPINOCORPUS_INCLUDE_DIR=/opt/alpinocorpus2/include \
        -DALPINOCORPUS_LIBRARIES=/opt/alpinocorpus2/lib/x86_64-linux-gnu/libalpinocorpus.so \
        -DXERCESC_INCLUDE_DIR=/opt/dbxml2/include \
        -DXERCESC_LIBRARY=/opt/dbxml2/lib/libxerces-c.so \
        -DXQILLA_INCLUDE_DIR=/opt/dbxml2/include \
        -DXQILLA_LIBRARY=/opt/dbxml2/lib/libxqilla.so \
        -DCMAKE_INSTALL_PREFIX=/opt/dact2 \
        .
    make
    make install

    cp .git/refs/heads/dbxml-2.5.16 ../dbxml-2.5.16-dact
fi

######## dact_v6

cd /dact

if [ ! -d dact_v6/.git ]
then
    rm -fr dact_v6
    git clone --depth=1 https://github.com/rug-compling/dact dact_v6
fi

cd dact_v6
git restore .  ## ivm patch
git pull

if [ ! -f ../master-dact_v6 ]
then
    touch ../master-dact_v6
fi

if diff -q ../master-dact_v6 .git/HEAD
then
    echo geen veranderingen in dact_v6
else
    # qt5 op Xenial is te oud:
    patch -p1 < /src/dact_v6.diff

    export LDFLAGS="-Wl,-rpath=/opt/alpinocorpus6/lib/x86_64-linux-gnu:/opt/dbxml6/lib"
    export PKG_CONFIG_PATH=/opt/alpinocorpus6/lib/x86_64-linux-gnu/pkgconfig
    rm -rf builddir /opt/dact6
    meson.py builddir -D dbxml_bundle=/opt/dbxml6 --prefix=/opt/dact6
    ninja -C builddir install
    rm -rf builddir

    # undo patch
    git restore .

    cp .git/HEAD ../master-dact_v6
fi
