kubectl apply -f pod.yaml
sleep 2
kubectl get pods
sleep 2
kubectl -n default replace --raw /api/v1/namespaces/default/pods/test/ephemeralcontainers -f ec.json
