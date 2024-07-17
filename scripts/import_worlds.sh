#!/bin/bash
if [ -f scripts/set_worlds_dirs.sh ];
then
    . scripts/set_worlds_dirs.sh

    PUBLIC_IP=$1

    WORLDS_DIRS=(${WORLDS_DIRS[@]})

    for WORLD_DIR in $WORLDS_DIRS; do
        if [ -d "$WORLD_DIR" ];
        then
            echo "Copying $WORLD_DIR to remote server..."
            rsync -avz -e "ssh -i keys/foundry.pem -o StrictHostKeyChecking=accept-new" "$WORLD_DIR" ec2-user@"$PUBLIC_IP":~/.local/share/FoundryVTT/Data/worlds/
            echo "Successfully copied $WORLD_DIR."
            rm -rf $WORLD_DIR
            echo "Deleted $WORLD_DIR."
        fi
    done
fi
echo "World import complete."