#!/usr/bin/env bash

kubectx kind-webhook

echo kubectl delete -f shadow-api-server.yaml
kubectl delete -f shadow-api-server.yaml
