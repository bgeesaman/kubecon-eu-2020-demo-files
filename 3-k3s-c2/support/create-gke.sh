#!/usr/bin/env bash

gcloud config set project gke-c2

gcloud beta container --project "gke-c2" clusters create "gke-c2" \
  --zone "us-central1-a" \
  --no-enable-basic-auth \
  --cluster-version "1.14.10-gke.46" \
  --machine-type "n1-standard-1" \
  --image-type "COS" \
  --disk-type "pd-standard" \
  --disk-size "100" \
  --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
  --num-nodes "3" \
  --enable-stackdriver-kubernetes \
  --enable-ip-alias \
  --default-max-pods-per-node "110" \
  --addons HorizontalPodAutoscaling,HttpLoadBalancing \
  --enable-autoupgrade \
  --enable-autorepair

gcloud container clusters get-credentials gke-c2 --zone us-central1-a
