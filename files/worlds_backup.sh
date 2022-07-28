#!/bin/bash

export GIT_SSH_COMMAND="/usr/bin/ssh -i ~/.ssh/id_ed25519"

# Git: add, commit changes and send data to Git server
for PATH in ~/.local/share/FoundryVTT/Data/worlds/*; do
    if [ -d $PATH ]; then
        cd $PATH
        echo "Backuping the world on path: $PATH"
        /usr/bin/git add --all
        /usr/bin/git commit -m "daily crontab backup `/usr/bin/date`"
        /usr/bin/git push -u origin main
        echo "Backuping completed"
    fi
done