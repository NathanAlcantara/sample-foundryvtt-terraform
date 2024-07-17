#!/bin/bash
echo "Installing openssl-devel..."
sudo yum install -y openssl-devel
echo "Installing Node.js..."
curl --silent --location https://rpm.nodesource.com/setup_20.x | sudo bash -
sudo yum install -y nodejs

echo "Installing jq and unzip..."
sudo yum install -y jq unzip

echo "Installing pm2..."
sudo npm install pm2 -g

echo "Creating directories..."
mkdir -p ~/foundryvtt

echo "Changing directory to ~/foundryvtt..."
cd ~/foundryvtt

echo "Unzipping foundryvtt.zip..."
unzip -oq foundryvtt.zip
rm foundryvtt.zip

echo "Setting up pm2 startup..."
pm2 startup
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ec2-user --hp /home/ec2-user

echo "Deleting existing foundry process..."
pm2 delete foundry

echo "Starting foundry..."
pm2 start "node ~/foundryvtt/resources/app/main.js" --name "foundry"