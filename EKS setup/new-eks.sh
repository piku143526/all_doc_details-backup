#!/bin/bash
# Define variables
cluster_name="prod-moneybridge"
region="eu-north-1"
private_subnets="subnet-02621c86fb3d7011f,subnet-0716e1d44ae8da33b"
namespace_name="moneybridge-ns"
instance_type="t3.large"
desired_capacity=1
min_size=1
max_size=2
volume_size=150
vpc_id="vpc-0318da71c4eccddb0"
aws_account_id="542664341044"

# Create EKS cluster
eksctl create cluster --name="$cluster_name" \
                      --region="$region" \
                      --vpc-private-subnets="$private_subnets" \
                      --without-nodegroup
# Associate IAM OIDC provider
eksctl utils associate-iam-oidc-provider \
    --region "$region" \
    --cluster "$cluster_name" \
    --approve

# Create NodeGroup configuration file426679853734
tee node.yml > /dev/null <<EOF
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: $cluster_name
  region: $region
managedNodeGroups:
  - name: ${cluster_name}-ng
    instanceType: $instance_type
    desiredCapacity: $desired_capacity
    minSize: $min_size
    maxSize: $max_size
    volumeSize: $volume_size
    privateNetworking: true
    ssh:
      publicKeyName: prod-moneybridge
EOF

# Create NodeGroup
eksctl create nodegroup --config-file node.yml

# Create a Kubernetes namespace
tee namespace.yml > /dev/null <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $namespace_name
EOF

kubectl apply -f namespace.yml

# Ingress

# Download IAM policy document
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.7/docs/install/iam_policy.json

# Create IAM policy
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json

# Create IAM service account for AWS Load Balancer Controller
eksctl create iamserviceaccount \
  --cluster="$cluster_name" \
  --namespace=kube-system \
  --name=aws-load-balancer-controller1 \
  --attach-policy-arn=arn:aws:iam::$aws_account_id:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve

# Install AWS Load Balancer Controller using Helm
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName="$cluster_name" \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller1 \
  --set region="$region" \
  --set vpcId="$vpc_id" \
  --set image.repository=602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon/aws-load-balancer-controller

# Create EKS addon for AWS EBS CSI Driver
eksctl create addon --name aws-ebs-csi-driver --cluster "$cluster_name" --service-account-role-arn arn:aws:iam::$aws_account_id:role/AmazonEKS_EBS_CSI_DriverRole --force

# Create IAM service account for EBS CSI Driver
eksctl create iamserviceaccount \
    --name ebs-csi-controller-sa \
    --namespace kube-system \
    --cluster "$cluster_name" \
    --role-name AmazonEKS_EBS_CSI_DriverRole \
    --role-only \
    --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
    --approve

# Create StorageClass for EBS CSI Driver
tee storage-class.yml > /dev/null <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-sc
provisioner: ebs.csi.aws.com
reclaimPolicy: Retain
EOF

kubectl apply -f storage-class.yml

# Install Loki and Grafana using Helm
#helm upgrade --install loki grafana/loki-stack --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false,loki.persistence.enabled=true,loki.persistence.storageClassName=ebs-sc,loki.persistence.size=10Gi
aws eks --region eu-north-1 update-kubeconfig --name prod-moneybridge