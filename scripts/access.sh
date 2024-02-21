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
