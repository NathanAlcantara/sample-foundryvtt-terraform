#!/bin/bash

if [ -f files/foundry-environment.json ];
then
  PUBLIC_DNS=$1

  SETUP_URL="$PUBLIC_DNS/setup"

  SYSTEM_MANIFEST=`cat files/foundry-environment.json | jq -r '.system.manifest'`

  curl -s "$SETUP_URL" \
    -H 'Content-Type: application/json' \
    --data-raw '{"action":"installPackage","type":"system","manifest":"'$SYSTEM_MANIFEST'"}' \
    --compressed

  MODULES_MANIFEST=`cat files/foundry-environment.json | jq -r '.modules[].manifest'`

  for MODULE_MANIFEST in $MODULES_MANIFEST; do
    curl "$SETUP_URL" \
    -H 'Content-Type: application/json' \
    --data-raw '{"action":"installPackage","type":"module","manifest":"'$MODULE_MANIFEST'"}' \
    --compressed \
    --insecure
  done
fi