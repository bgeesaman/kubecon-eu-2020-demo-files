#!/usr/bin/env bash
set -eo pipefail

CERT="`cat cert.pem`"

cat <<EOF
---
apiVersion: admissionregistration.k8s.io/v1beta1
kind: ValidatingWebhookConfiguration
metadata:
  name: validator
  labels:
    app: validator
webhooks:
  - name: validator.default.svc.cluster.local
    failurePolicy: Ignore
    timeoutSeconds: 1
    clientConfig:
      caBundle: $CERT
      service:
        name: validator
        namespace: default
        path: "/validator"
    rules:
      - operations: ["CREATE","UPDATE","DELETE"]
        apiGroups: ["*"]
        apiVersions: ["*"]
        resources: ["secrets"]
        #resources: ["*"]
EOF
