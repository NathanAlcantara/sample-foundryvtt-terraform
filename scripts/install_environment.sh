#!/bin/bash

if [ -f files/foundry-environment.json ];
then
  BASE_URL="https://$1"

  SETUP_URL="$BASE_URL/setup"

  SYSTEM_MANIFEST=`cat files/foundry-environment.json | jq -r '.system.manifest'`

  echo "Installing system package..."
  curl -s "$SETUP_URL" \
    -H 'Content-Type: application/json' \
    --data-raw '{"action":"installPackage","type":"system","manifest":"'$SYSTEM_MANIFEST'"}' \
    --compressed

  MODULES_MANIFEST=`cat files/foundry-environment.json | jq -r '.modules[].manifest'`

  echo "Installing module packages..."
  for MODULE_MANIFEST in $MODULES_MANIFEST; do
    echo "Installing module package: $MODULE_MANIFEST"
    curl "$SETUP_URL" \
    -H 'Content-Type: application/json' \
    --data-raw '{"action":"installPackage","type":"module","manifest":"'$MODULE_MANIFEST'"}' \
    --compressed \
    --insecure
  done
fi