#!/bin/sh

# scripts is adding AWS Security Group rule for certificate add or renewal
# EC2 IAM role should have attached policy which allows add and delete SG

if [ "${AWS_INTEGRATED}" == "true" ]; then
    if [ -z "$(which aws)" ]; then
        apk add --no-cache aws-cli && echo "aws-cli installed"
    fi
    
    if [ "$1" == "add" ] && [ ! -z "${AWS_REGION}" ] && [ ! -z "${AWS_SG_ID}" ]; then
        aws ec2 authorize-security-group-ingress --region ${AWS_REGION} --group-id "${AWS_SG_ID}" --protocol tcp --port 80 --cidr "0.0.0.0/0" --output text
    fi

    if [ "$1" == "del" ] && [ ! -z "${AWS_REGION}" ] && [ ! -z "${AWS_SG_ID}" ]; then
        aws ec2 revoke-security-group-ingress --region ${AWS_REGION} --group-id "${AWS_SG_ID}" --protocol tcp --port 80 --cidr "0.0.0.0/0" --output text
    fi
else
    echo "aws integration disabled"
fi