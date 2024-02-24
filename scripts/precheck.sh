#!/bin/bash

case `hostname -f` in
    *rug*)
        ;;
    *)
        exit 0
        ;;
esac

if [ "`id -gn`" != software -o "`umask`" != 0002 ]
then
    echo
    echo Doe eerst dit:
    echo
    echo newgrp software
    echo umask 0002
    echo
    exit 1
fi
