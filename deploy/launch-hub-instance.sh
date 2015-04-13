#!/usr/bin/bash

INSTANCE_ID=$(aws ec2 run-instances --image-id ami-7f89a64f --count 1 --instance-type t1.micro --key-name crewatlas --security-groups=default)
echo $INSTANCE_ID
#Retrieve the instance ID with python, super tacky
INSTANCE_ID=$(echo $INSTANCE_ID | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["Instances"][0]["InstanceId"]')

aws ec2 wait instance-status-ok --instance-ids=$INSTANCE_ID
PUBLIC_DNS=$(aws ec2 describe-instances --instance-ids=$INSTANCE_ID)
echo $PUBLIC_DNS
PUBLIC_DNS=$(echo $PUBLIC_DNS | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["Reservations"][0]["Instances"][0]["PublicDnsName"]')

ssh -i $1 ubuntu@$PUBLIC_DNS << EOF

sudo apt-get install git

cd /home/ubuntu

git clone https://github.com/khous/hub.git
cd hub/deploy 
sh setup-remote-server.sh

EOF