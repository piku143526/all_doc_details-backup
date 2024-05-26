#!/bin/bash

# Set variables
PROJECT_ID="playground-s-11-e496997e"
VPC_NAME="stage-demo-vpc"
PUBLIC_SUBNET_NAME="stage-public-subnet"
PRIVATE_SUBNET_NAME="stage-private-subnet"
FIREWALL_RULE_CUSTOM="stage-demo-vpc-allow-custom"
FIREWALL_RULE_ICMP="stage-demo-vpc-allow-icmp"
STATIC_IP_NAME="stage-demo-ip"
ROUTER_NAME="stage-demo-router"

# Step 1: Create VPC
gcloud compute networks create $VPC_NAME \
  --project=$PROJECT_ID \
  --description=$VPC_NAME \
  --subnet-mode=custom \
  --mtu=1460 \
  --bgp-routing-mode=regional

gcloud compute networks subnets create $PUBLIC_SUBNET_NAME \
  --project=$PROJECT_ID \
  --description="$PUBLIC_SUBNET_NAME" \
  --range=10.0.1.0/24 \
  --stack-type=IPV4_ONLY \
  --network=$VPC_NAME \
  --region=us-east1

gcloud compute networks subnets create $PRIVATE_SUBNET_NAME \
  --project=$PROJECT_ID \
  --description="$PRIVATE_SUBNET_NAME" \
  --range=10.0.50.0/24 \
  --stack-type=IPV4_ONLY \
  --network=$VPC_NAME \
  --region=us-east1

gcloud compute firewall-rules create $FIREWALL_RULE_CUSTOM \
  --project=$PROJECT_ID \
  --network=projects/$PROJECT_ID/global/networks/$VPC_NAME \
  --description="Allows connection from any source to any instance on the network using custom protocols." \
  --direction=INGRESS \
  --priority=65534 \
  --source-ranges=10.0.1.0/24,10.0.50.0/24 \
  --action=ALLOW \
  --rules=all

gcloud compute firewall-rules create $FIREWALL_RULE_ICMP \
  --project=$PROJECT_ID \
  --network=projects/$PROJECT_ID/global/networks/$VPC_NAME \
  --description="Allows ICMP connections from any source to any instance on the network." \
  --direction=INGRESS \
  --priority=65534 \
  --source-ranges=0.0.0.0/0 \
  --action=ALLOW \
  --rules=icmp

# Step 2: Create Static IP address (Reserve a static address)
gcloud compute addresses create $STATIC_IP_NAME \
  --project=$PROJECT_ID \
  --description="Reserve a static address" \
  --region=us-east1

# Step 3: Create Cloud Router  
gcloud compute routers create $ROUTER_NAME \
  --project=$PROJECT_ID \
  --description=$ROUTER_NAME \
  --region=us-east1 \
  --network=$VPC_NAME
# create cloud nat
