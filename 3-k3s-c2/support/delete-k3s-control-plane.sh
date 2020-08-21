#!/usr/bin/env bash

gcloud config set project gke-c2

gcloud beta compute --project=gke-c2 instances delete k3s-control-plane --zone=us-east4-a -q

gcloud compute --project=gke-c2 firewall-rules delete default-allow-https -q
