#!/bin/bash

KEY=$1
SECRET=$2

echo '{
    "accessKeyId": "'$KEY'",
    "secretAccessKey": "'$SECRET'",
    "region": "us-east-1"
}' > files/aws.json