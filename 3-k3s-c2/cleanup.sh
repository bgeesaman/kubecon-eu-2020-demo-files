#!/bin/bash

#gcloud compute --project=gke-c2 ssh k3s-control-plane --zone=us-east4-a

echo "cleaning gke"
kubectx gke_gke-c2_us-central1-a_gke-c2 2> /dev/null 1> /dev/null
kubectl apply -f support/cleaner.yaml 2> /dev/null 1> /dev/null
echo "cleaning eks"
kubectx bglonimbus@eks-c2.us-east-2.eksctl.io 2> /dev/null 1> /dev/null
kubectl apply -f support/cleaner.yaml 2> /dev/null 1> /dev/null
echo "cleaning aks"
kubectx aks-c2 2> /dev/null 1> /dev/null
kubectl apply -f support/cleaner.yaml 2> /dev/null 1> /dev/null

sleep 5

echo "removing gke"
kubectx gke_gke-c2_us-central1-a_gke-c2 2> /dev/null 1> /dev/null
kubectl delete -f support/cleaner.yaml 2> /dev/null 1> /dev/null
echo "removing eks"
kubectx bglonimbus@eks-c2.us-east-2.eksctl.io 2> /dev/null 1> /dev/null
kubectl delete -f support/cleaner.yaml 2> /dev/null 1> /dev/null
echo "removing aks"
kubectx aks-c2 2> /dev/null 1> /dev/null
kubectl delete -f support/cleaner.yaml 2> /dev/null 1> /dev/null

gcloud config set project gke-c2

gcloud compute --project=gke-c2 ssh k3s-control-plane --zone=us-east4-a 2> /dev/null -- "export KUBECONFIG=/var/k3s/config/kubeconfig.yaml; kubectl delete node -l node-role.kubernetes.io/worker=true; kubectl delete -f metadata-stealer.yaml; kubectl delete -f secret-vacuum.yaml"
