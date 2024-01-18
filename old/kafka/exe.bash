#!/bin/bash

kubectl delete -f service.yml
kubectl delete -f source.yml
# docker compose down

# docker compose up -d
# sleep 3
kubectl apply -f service.yml
kubectl apply -f source.yml

# sleep 5
# time ./producer.py 500