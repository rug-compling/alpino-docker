#!/bin/bash

case `hostname -f` in
    *rug*)
        chgrp -cR software "$@"
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
            chmod -cR ug+w work/cache/go/pkg
            exit
            ;;
    esac
done

