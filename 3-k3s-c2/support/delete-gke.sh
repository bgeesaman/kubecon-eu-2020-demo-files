#!/usr/bin/env bash

gcloud config set project gke-c2

gcloud beta container --project gke-c2 clusters delete gke-c2 --zone=us-central1-a
