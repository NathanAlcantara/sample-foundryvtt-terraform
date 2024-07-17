#!/bin/bash

KEY=$1
SECRET=$2

echo '{
    "region": "us-east-1",
    "credentials": {
        "accessKeyId": "'$KEY'",
        "secretAccessKey": "'$SECRET'"
    }
}' > files/aws.json