#!/bin/bash

kubectl delete deployment attackpod 2> /dev/null 1> /dev/null
kubectl delete -f shadow-api-server.yaml 2> /dev/null 1> /dev/null
