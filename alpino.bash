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

if [ $# -lt 1 ]
then
    echo Usage: $0 workdir [command]
    exit
fi

DIR="$1"
shift

if [ ! -d "$DIR" -o ! -r "$DIR" ]
then
    echo
    echo "'$DIR'" is not a readable directory
    echo
    exit
fi

case "$DIR" in
    /*)
	;;
    *)
	echo
	echo workdir must be an absolute path
	echo "'$DIR'" is not an absolute path
	echo
	exit
	;;
esac

os=`docker version -f {{.Client.Os}}`

if [ "$os" = "linux" ]
then
    st=`stat -f -c %T "$DIR"`
    case "$st" in
	nfs*)
	    P=`dir="$DIR" perl -e "$script"`
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
fi

docker run \
       --net=host \
       --user=`id -u`:`id -g` \
       --rm \
       -i -t \
       -e DISPLAY \
       -v "$DIR":/work/data \
       rugcompling/alpino:latest "$@"
