#!/bin/bash

set -e

if [ -f /sp/ok ]
then
    echo SICStus is al geïnstalleerd
    exit 0
fi

rm -fr /sp/*

cd /sp-3.12.11

rm -f platform.cache
cp install.cache.in install.cache
./InstallSICStus --batch
touch /sp/ok

