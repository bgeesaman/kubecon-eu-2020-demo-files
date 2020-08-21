#!/usr/bin/env bash

aws-vault exec -n lonimbus -- eksctl create cluster -f eks.yaml
