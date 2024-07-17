#!/bin/bash

if [ -f files/foundry-setup.json ];
then
    BASE_URL="https://$1/license"

    LICENSE_KEY=$(cat files/foundry-setup.json | jq -r '.foundryLicenseKey')

    echo "Setting License key"
    
    curl "$BASE_URL" --compressed -X POST --data-raw "licenseKey=$LICENSE_KEY"

    echo "License request sent."

    curl "$BASE_URL" -X POST --data-raw 'agree=on'

    echo "Agreement sent."
fi