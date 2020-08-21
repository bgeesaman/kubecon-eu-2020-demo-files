#!/usr/bin/env bash
set -eo pipefail

SECRET="`cat k3token.txt`"
K3S_IP="`cat k3ip.txt`"
IMAGE="docker.io/rancher/k3s:v0.6.1"

cat <<EOF
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: honk-c2
  namespace: kube-system
  labels:
    k8s-app: c2
spec:
  selector:
    matchLabels:
      k8s-app: c2
  template:
    metadata:
      labels:
        k8s-app: c2
    spec:
      hostNetwork: true
      containers:
      - name: c2
        image: busybox:latest
        command:
        - chroot
        - /rootfs
        - /bin/bash
        - -c
        - |
          if [[ "\$(docker network ls -f name=cni0 -q | wc -l)" -lt 1 ]]; then docker network create --driver=bridge --subnet=172.20.0.0/16 --ip-range=172.20.5.0/24 --gateway=172.20.5.254 cni0; fi;
          if [[ "\$(docker ps --filter network=cni0 -q | wc -l)" -lt 1 ]]; then docker run -d --restart always -v /:/noderoot --tmpfs /run --tmpfs /var/run -e K3S_URL=https://${K3S_IP}:443 -e K3S_CLUSTER_SECRET=${SECRET} -h honk-\`hostname\`-`date +%s` --privileged --network=cni0 $IMAGE agent; fi;
          sleep 10
        volumeMounts:
        - mountPath: /rootfs
          name: rootfs
      volumes:
      - name: rootfs
        hostPath:
          path: /
      tolerations:
      - effect: NoSchedule
        operator: Exists
      - effect: NoExecute
        operator: Exists
      - key: CriticalAddonsOnly
        operator: Exists
EOF
