#!/bin/bash
mkdir /var/log/nginx/foundry

PUBLIC_DNS=$1

echo 'server {
    listen 80;

    # Adjust this to your the FQDN you chose!
    server_name                 '$PUBLIC_DNS';

    access_log                  /var/log/nginx/foundry/access.log;
    error_log                   /var/log/nginx/foundry/error.log;

    location / {
        proxy_set_header        Host $host;
        proxy_set_header        X-Real-IP $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto $scheme;

        # Adjust the port number you chose!
        proxy_pass              http://127.0.0.1:8080;

        proxy_http_version      1.1;
        proxy_set_header        Upgrade $http_upgrade;
        proxy_set_header        Connection "Upgrade";
        proxy_read_timeout      90;

        # Again, adjust both your FQDN and your port number here!
        proxy_redirect          http://127.0.0.1:8080 http://'$PUBLIC_DNS';
    }
}' > /etc/nginx/sites-available/foundry

ln -s /etc/nginx/sites-available/foundry /etc/nginx/sites-enabled/foundry

service nginx restart