#!/usr/bin/env bash

gcloud config set project gke-c2

gcloud compute --project=gke-c2 ssh k3s-control-plane --zone=us-east4-a
