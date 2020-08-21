#!/usr/bin/env bash

az login

az group create --name myResourceGroup --location eastus

az aks create --resource-group myResourceGroup --name aks-c2 --node-count 3 --enable-addons monitoring --generate-ssh-keys

az aks get-credentials --resource-group myResourceGroup --name aks-c2
