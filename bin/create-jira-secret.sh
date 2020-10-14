#!/bin/bash

if [ -z "$1" ] || [ "$1" == "-h" ]; then
    echo "Usage: $0 SECRET_NAME SECRET_VALUE"
    exit 1
fi

aws secretsmanager create-secret \
    --region us-east-1 \
    --name $1 \
    --secret-string="$2" \
    --tags '[{"Key":"terraform_managed", "Value":"false"}]'
