#!/bin/bash

delete () {
    kubectl delete -f ./source/source.yml
    kubectl delete -f ./broker/source.yml
    kubectl delete -f ./broker/trigger.yml
    kubectl delete -f ./broker/broker.yml
    kubectl delete -f ./service.yml
}

delete

# source型
kubectl apply -f service.yml
kubectl apply -f ./source/source.yml

# # broker型
# kubectl apply -f ./service.yml
# kubectl apply -f ./broker/broker.yml
# kubectl apply -f ./broker/trigger.yml
# kubectl apply -f ./broker/source.yml

# sleep 5
# time ./client.py 500
