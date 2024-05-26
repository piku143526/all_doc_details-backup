#!/bin/bash

# Set your project ID
PROJECT_ID="playground-s-11-e496997e"

# Set cluster parameters
CLUSTER_NAME="stage-demo-cluster"
CLUSTER_VERSION="1.27.3-gke.100"
MACHINE_TYPE="e2-medium"
IMAGE_TYPE="UBUNTU_CONTAINERD"
DISK_TYPE="pd-balanced"
DISK_SIZE="50"
NUM_NODES="1"
MASTER_IP_CIDR="172.16.0.0/28"
NETWORK="projects/${PROJECT_ID}/global/networks/stage-demo-vpc"
SUBNETWORK="projects/${PROJECT_ID}/regions/us-east1/subnetworks/stage-private-subnet"

# Set maintenance window parameters
MAINTENANCE_WINDOW_START="2024-02-02T18:30:00Z"
MAINTENANCE_WINDOW_END="2024-02-03T18:30:00Z"
MAINTENANCE_WINDOW_RECURRENCE="FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR,SA,SU"

# Run gcloud command to create the GKE cluster
gcloud beta container clusters create "${CLUSTER_NAME}" \
  --project "${PROJECT_ID}" \
  --no-enable-basic-auth \
  --cluster-version "${CLUSTER_VERSION}" \
  --release-channel "regular" \
  --machine-type "${MACHINE_TYPE}" \
  --image-type "${IMAGE_TYPE}" \
  --disk-type "${DISK_TYPE}" \
  --disk-size "${DISK_SIZE}" \
  --metadata disable-legacy-endpoints=true \
  --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
  --num-nodes "${NUM_NODES}" \
  --logging=SYSTEM \
  --monitoring=SYSTEM \
  --enable-private-nodes \
  --master-ipv4-cidr "${MASTER_IP_CIDR}" \
  --enable-ip-alias \
  --network "${NETWORK}" \
  --subnetwork "${SUBNETWORK}" \
  --no-enable-intra-node-visibility \
  --default-max-pods-per-node "110" \
  --security-posture=standard \
  --workload-vulnerability-scanning=disabled \
  --no-enable-master-authorized-networks \
  --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver \
  --enable-autoupgrade \
  --enable-autorepair \
  --max-surge-upgrade 1 \
  --max-unavailable-upgrade 0 \
  --maintenance-window-start "${MAINTENANCE_WINDOW_START}" \
  --maintenance-window-end "${MAINTENANCE_WINDOW_END}" \
  --maintenance-window-recurrence "${MAINTENANCE_WINDOW_RECURRENCE}" \
  --binauthz-evaluation-mode=DISABLED \
  --enable-managed-prometheus \
  --enable-vertical-pod-autoscaling \
  --enable-shielded-nodes \
  --node-locations "us-east1-b"

