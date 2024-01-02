#!/bin/bash
NAMES=("web" "mongodb" "mysql" "catalogue" "redis" "user" "cart" "shipping" "rabitmq" "payment" "dispatch")
IMAGE_ID=ami-03265a0778a880afb
INSTANCE_TYPE=""
SECURITY_GROUPS_ID=sg-011b08d9d08f709ad
DOMAIN_NAME=mydomainproject.tech
for i in "${NAMES[@]}"
do 
  if [[ $i == "mysql" || $i == "mongodb" ]]
  then
    INSTANCE_TYPE="t3.medium"
  else
    INSTANCE_TYPE="t2.micro"
  fi
  echo "creating $i instance"
  # to create instance
  IPADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUPS_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
  echo "instance $i created, ipv4:$IPADDRESS"
  # creating record for the created instance in the hosted zone provided
  aws route53 change-resource-record-sets --hosted-zone-id Z10457712MLJ73G2PH9K9 --change-batch '
  {
            "Comment": "CREATE/DELETE/UPSERT a record ",
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                                    "Name": "'$i.$DOMAIN_NAME'",
                                    "Type": "A",
                                    "TTL": 300,
                                 "ResourceRecords": [{ "Value": "'$IPADDRESS'"}]
            }}]
  }'
done