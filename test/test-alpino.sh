#!/bin/bash

rm out/*.xml
../alpino.bash `pwd` /bin/sh -c 'partok /work/voorbeelden/weerbericht.txt | Alpino -flag treebank /work/data/out debug=1 end_hook=xml user_max=900000 -parse' | tee out/log
echo
echo 'THERE SHOULD BE NO DIFFERENCES EXCEPT FOR <parser ... date /> :'
echo
for i in ori/*.xml
do
    diff -U0 -s $i out/`basename $i`
done
