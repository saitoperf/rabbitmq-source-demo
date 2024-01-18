#!/bin/bash

delete () {
    # docker compose down
    kubectl delete secret rabbit-auth
    kubectl delete -f ./source/source.yml
    kubectl delete -f ./broker/source.yml
    kubectl delete -f ./broker/trigger.yml
    kubectl delete -f ./broker/broker.yml
    kubectl delete -f ./service.yml
}

delete

# 共通設定
# docker compose up -d
kubectl create secret generic --save-config rabbit-auth \
  --from-literal=username=admin \
  --from-literal=password=P@ssw0rd \
  --from-literal=uri=192.168.1.11
kubectl apply -f service.yml

# source型
kubectl apply -f ./source/source.yml

# # broker型
# kubectl apply -f ./broker/broker.yml
# kubectl apply -f ./broker/trigger.yml
# kubectl apply -f ./broker/source.yml

# sleep 5
# time ./client.py 500
