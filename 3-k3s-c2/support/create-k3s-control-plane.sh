#!/usr/bin/env bash

gcloud config set project gke-c2

gcloud beta compute --project=gke-c2 instances create k3s-control-plane \
  --zone=us-east4-a \
  --machine-type=n1-standard-1 \
  --subnet=default \
  --network-tier=PREMIUM \
  --metadata-from-file startup-script=k3s-startup-script.sh \
  --maintenance-policy=MIGRATE \
  --service-account=310139068271-compute@developer.gserviceaccount.com \
  --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
  --tags=https-server \
  --image=cos-69-10895-385-0 \
  --image-project=cos-cloud \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=k3s-control-plane \
  --reservation-affinity=any

gcloud compute --project=gke-c2 firewall-rules create default-allow-https \
  --direction=INGRESS \
  --priority=1000 \
  --network=default \
  --action=ALLOW \
  --rules=tcp:443 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=https-server

gcloud compute instances describe k3s-control-plane --zone=us-east4-a \
  --format='get(networkInterfaces[0].accessConfigs[0].natIP)' > ../k3ip.txt
