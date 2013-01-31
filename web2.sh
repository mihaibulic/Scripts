#!/bin/bash
set -e 

APT_GET_INSTALL="sudo apt-get install -y -q";

if [ $# != 2 ]; then
    echo "run as $0 <AWSAccessKeyId> <AWSSecretKey>";
    exit;
fi

mkdir -m 0700 -p $HOME/.aws;
cp $HOME/Downloads/*.pem $HOME/.aws;

echo "AWSAccessKeyId=$1" > $HOME/.aws/aws-credential-file.txt;
echo "AWSSecretKey=$2" >> $HOME/.aws/aws-credential-file.txt;

echo "" >> $HOME/.bashrc;
echo "# AWS credentials" >> $HOME/.bashrc;
echo "export EC2_PRIVATE_KEY=$(echo $HOME/.aws/pk-*.pem)" >> $HOME/.bashrc;
echo "export EC2_CERT=$(echo $HOME/.aws/cert-*.pem)" >> $HOME/.bashrc;
echo "export AWS_CREDENTIAL_FILE=$HOME/.aws/aws-credential-file.txt" >> $HOME/.bashrc;
source $HOME/.bashrc;

sudo apt-add-repository ppa:awstools-dev/awstools;
sudo apt-get update;
$APT_GET_INSTALL ec2-api-tools ec2-ami-tools iamcli rdscli aws-cloudformation-cli elbcli;

cfn-list-stacks;
RET1=$?;
elb-describe-lb-policies;
RET2=$?;

if [ $RET1 == 0 && $RET2 == 0]; then
    echo "***** EVERYTHING WORKS *****";
else
    echo "***** SOMETHING IS BROKEN *****";
fi

