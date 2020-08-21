#!/usr/bin/env bash

az login

az aks delete --resource-group myResourceGroup --name aks-c2
