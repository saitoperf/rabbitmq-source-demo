#!/bin/bash

# docker compose down
kubectl delete -f source.yml
kubectl delete -f service.yml

# docker compose up -d
kubectl apply -f service.yml
kubectl apply -f source.yml

# sleep 5
# time ./client.py 500
