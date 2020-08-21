#!/usr/bin/env bash

kind create cluster --config kind.yaml --image kindest/node:v1.17.2

docker exec -it $(docker ps -f name=kind-worker -q) /bin/bash -c 'if [[ $(cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf | grep dynamic-config | wc -l) -lt 1 ]]; then sed -ie "s#\$KUBELET_EXTRA_ARGS#--dynamic-config-dir=/var/lib/kubelet/config/dynamic#g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf; systemctl daemon-reload; fi; systemctl restart kubelet'

kubectl apply -f coredns-cm.yaml
kubectl delete pod -n kube-system -l k8s-app=kube-dns
