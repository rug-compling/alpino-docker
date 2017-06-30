#!/bin/bash

rm out/*.xml
cp ori/*.xml out
../alpino.bash `pwd` /bin/sh -c 'HOME=/work dttred /work/data/out/*.xml'
