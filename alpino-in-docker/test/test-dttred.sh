#!/bin/bash

rm out/*.xml
cp ori/*.xml out
../alpino.bash `pwd` /bin/sh -c 'HOME=/work dttred /work/data/out/*.xml'
for i in ori/*.xml
do
    diff -u -b $i out/`basename $i`
done
