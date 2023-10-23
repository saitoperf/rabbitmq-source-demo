#!/bin/bash

kubectl delete -f service.yml
kubectl delete -f source.yml

kubectl apply -f service.yml
kubectl apply -f source.yml

# sleep 5
# time ./client.py 500