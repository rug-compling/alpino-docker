#!/bin/bash

case `hostname -f` in
    *rug*)
        chgrp -cR software "$@"
        chmod -cR g+w "$@"
        ;;
    *)
        case `docker info --format '{{.SecurityOptions}}'` in
            *rootless*)
                ;;
            *)
                sudo chown -cR peter:peter "$@"
                ;;
        esac
        ;;
esac

for i in "$@"
do
    case $i in
        *work/cache*)
            if [ -d work/cache/go/pkg ]
            then
                chmod -cR ug+w work/cache/go/pkg
            fi
            exit
            ;;
    esac
done

