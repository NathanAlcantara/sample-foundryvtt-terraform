#!/bin/bash

#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "30 1 * * 2,6 bash /home/ubuntu/scripts/worlds_backup.sh" >> mycron
#install new cron file
crontab mycron
rm mycron