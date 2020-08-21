#!/bin/bash

CLUSTER_TOKEN="somethingtotallyrandom"
K3S_IMAGE="docker.io/rancher/k3s:v0.6.1"

mkdir -p /var/k3s/server /var/k3s/config
cd /var/k3s/config

sleep 60

docker run -d --restart always -h "docker-`hostname`" -e K3S_CLUSTER_SECRET=${CLUSTER_TOKEN} -e K3S_KUBECONFIG_OUTPUT=/output/kubeconfig.yaml -e K3S_KUBECONFIG_MODE=644 -v /var/k3s/config:/output --tmpfs /run --tmpfs /var/run -p 443:6443 -p6443:6443 --privileged ${K3S_IMAGE} server
