#!/bin/bash

PUBLIC_DNS=$1

#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "@reboot sleep 60 && bash /home/ubuntu/scripts/initiate_world.sh $PUBLIC_DNS" >> mycron
echo "30 1 * * 2,6 bash /home/ubuntu/scripts/worlds_backup.sh" >> mycron
#install new cron file
crontab mycron
rm mycron