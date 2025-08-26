#!/bin/bash

set -e

if [ -f /opt/perl/ok ]
then
    echo Perl is al geïnstalleerd
    exit 0
fi

cd /
tar vxzf /src/perl5-5.30.3.tar.gz
cd perl5-5.30.3
export LDFLAGS="-Wl,-rpath=/opt/perl/lib"
./Configure -Dprefix=/opt/perl -de
make
make install

PATH=/opt/perl/bin:$PATH
yes | cpan LWP::Protocol::http LWP::Protocol::https

touch /opt/perl/ok
