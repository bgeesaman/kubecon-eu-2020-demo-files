#!/usr/bin/env bash

aws-vault exec -n lonimbus -- eksctl delete cluster -f eks.yaml
