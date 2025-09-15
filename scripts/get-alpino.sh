#!/bin/bash

set -e

git lfs install

mkdir -p alpino
cd alpino

if [ ! -d Alpino/.git ]
then
    rm -fr Alpino
    git clone --depth=1 https://github.com/rug-compling/Alpino
fi

cd Alpino
git pull
