#!/bin/bash

if [ -f files/foundry-setup.json ];
then
    ADMIN_PASS=$(cat files/foundry-setup.json | jq -r '.adminPass')
    WORLD_TO_INITIATE=$(cat files/foundry-setup.json | jq -r '.worldToInitiate')

    BASE_URL="https://$1"

    AUTH_URL="$BASE_URL/auth"

    echo "Sending admin authentication request..."
    curl $AUTH_URL -X POST \
        -H 'Content-Type: application/json' \
        --data-raw '{"action":"adminAuth","adminKey":"'$ADMIN_PASS'"}' \
        --cookie-jar cookies.txt

    COOKIE_STR=$(cat cookies.txt)
    rm cookies.txt

    SEARCHSTRING="session"

    REST=${COOKIE_STR#*$SEARCHSTRING}
    INDEX=$(( ${#COOKIE_STR} - ${#REST} ))
    COOKIE=${COOKIE_STR:INDEX}
    COOKIE=${COOKIE##*( )}

    SETUP_URL="$BASE_URL/setup"

    echo "Launching world: $WORLD_TO_INITIATE"
    curl "$SETUP_URL" \
        -H 'Content-Type: application/json' \
        -H "Cookie: session=$COOKIE" \
        --data-raw '{"action":"launchWorld","world":"'$WORLD_TO_INITIATE'"}'
fi