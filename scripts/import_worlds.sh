#!/bin/bash

if [ -f scripts/set_worlds_dirs.sh ];
then
    . scripts/set_worlds_dirs.sh

    PUBLIC_IP=$1

    WORLDS_DIRS=(${WORLDS_DIRS[@]})

    for WORLD_DIR in $WORLDS_DIRS; do
        if [ -d "$WORLD_DIR" ];
        then
            scp -o StrictHostKeyChecking=accept-new -ri keys/foundry.pem $WORLD_DIR ubuntu@$PUBLIC_IP:~/.local/share/FoundryVTT/Data/worlds
        fi
    done
fi