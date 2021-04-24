#!/bin/bash
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

sudo apt-get install -y nginx unzip

sudo npm install pm2 -g

mkdir ~/foundry
cd ~/foundry

unzip -o foundryvtt.zip
rm foundryvtt.zip

pm2 startup
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 start "node ~/foundry/resources/app/main.js --port=8080" --name "foundry"