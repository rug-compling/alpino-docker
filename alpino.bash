#!/bin/bash

script='
@parts = ("/");
$p = "";
foreach $part (split m!/!, $ENV{dir}) {
    if ($part ne "") {
	$p .= "/" . $part;
	push @parts, $p;
    }
}
foreach $p (@parts) {
    $s = `stat -c %A "$p"`;
    if ($s =~ /d(...){0,2}..-/) {
        print "$p";
	exit;
    }
}
'

if [ $# != 1 ]
then
    echo Usage: $0 workdir
    exit
fi

if [ ! -d "$1" -o ! -r "$1" ]
then
    echo
    echo "'$1'" is not a readable directory
    echo
    exit
fi

case "$1" in
    /*)
	;;
    *)
	echo
	echo workdir must be an absolute path
	echo "'$1'" is not an absolute path
	echo
	exit
	;;
esac

st=`stat -f -c %T "$1"`
case "$st" in
    nfs*)
	P=`dir="$1" perl -e "$script"`
	if [ "$P" != "" ]
	then
	    echo
	    echo path "'$P'" must be executable for everybody
	    echo please do:
	    echo
	    echo "  chmod a+x $P"
	    echo
	    exit
	fi
	;;
esac

docker run \
       --net=host \
       --user=`id -u`:`id -g` \
       --rm \
       -i -t \
       -e DISPLAY \
       -v "$1":/work/data \
       rugcompling/alpino:latest
