#!/bin/bash

# Git: add, commit changes and send data to Git server
for PATH in ~/.local/share/FoundryVTT/Data/worlds/*; do
    if [ -d $PATH ]; then
        cd $PATH
        git pull origin main
        git add --all
        git commit -m "daily crontab backup `date`"
        git push origin main
    fi
done