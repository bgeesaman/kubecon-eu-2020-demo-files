#!/bin/bash

kubectl delete -f webhook.yaml 2> /dev/null 1> /dev/null
kubectl delete -f validator.yaml 2> /dev/null 1> /dev/null
kubectl delete secret validator 2> /dev/null 1> /dev/null
kubectl delete secret honk 2> /dev/null 1> /dev/null
rm cert.pem 2> /dev/null 1> /dev/null
