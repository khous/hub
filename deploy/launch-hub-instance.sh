#!/usr/bin/bash

INSTANCE_ID=$(aws ec2 run-instances --image-id ami-7f89a64f --count 1 --instance-type t1.micro --key-name crewatlas --security-groups=default)
#Retrieve the instance ID with python, super tacky
INSTANCE_ID=$(echo $INSTANCE_ID | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["Instances"][0]["InstanceId"]')
echo Instance ID $INSTANCE_ID
echo "waiting for instance status ok..."
aws ec2 wait instance-status-ok --instance-ids=$INSTANCE_ID
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids=$INSTANCE_ID)
PUBLIC_IP=$(echo $PUBLIC_IP | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["Reservations"][0]["Instances"][0]["PublicIpAddress"]')
echo Public IP $PUBLIC_IP

#For some reason, this cmd closes the ssh session after completing. I don't really care why at this point
ssh -o "StrictHostKeyChecking no" -i $1 ubuntu@$PUBLIC_IP 'sudo apt-get install -y git && sudo git clone https://github.com/khous/hub.git'

echo Connect and run setup-remote-server.sh ssh -i $1 ubuntu@$PUBLIC_IP