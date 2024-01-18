# knative-source
## Required
- kind

## Install
```bash
# Start kind
kind create cluster --config kind_config.yml
# Install knative operator
kubectl apply -f https://github.com/knative/operator/releases/download/knative-v1.12.2/operator.yaml
# Install knative-serving & knative-eventing
kubectl apply -f install/
# Start rabbitmq container
docker compose up -d
# Please replace x.x.x.x with the IP address of your host machine
# ex) sed 's/uri: .*/uri: '$(echo -n "192.168.1.11" | openssl base64)'/' rabbit-auth.yml | kubectl apply -f -
sed 's/uri: .*/uri: '$(echo -n "x.x.x.x" | openssl base64)'/' rabbit-auth.yml | kubectl apply -f -
# Install rabbitmq source
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.5.4/cert-manager.yaml
kubectl apply -f https://github.com/rabbitmq/messaging-topology-operator/releases/download/v1.10.0/messaging-topology-operator-with-certmanager.yaml
kubectl apply -f service.yml
kubectl apply -f source.yml
```

- Push 500 requests to RabbitMQ
```sh
sudo apt install python3-pika
time ./client.py 500
```

## Build event-display & push container registry
```sh
# pwd: knative-source/event-display
./build [container registry] # ex) ./build.sh docker.io/shiron228/event-display
cd ../
# Please specify the container registry in spec.template.spec.container[].image in service.yml
```

## Verify
```sh
# Confirm that 500 fn are activated
kubectl logs `kubectl get po | grep event-display | cut -f 1 -d ' '` | grep UTC | wc -l
kubectl logs `kubectl get po | grep event-display | cut -f 1 -d ' '` | grep UTC | sed -n '1p;$p'

# Number of requests received by source
kubectl logs  `kubectl get po | grep source | cut -f 1 -d ' '` | grep -e Received | wc -l
kubectl logs  `kubectl get po | grep source | cut -f 1 -d ' '` | grep -e Successfully | wc -l

# Time difference between first and last request
kubectl logs  `kubectl get po | grep source | cut -f 1 -d ' '` | grep -e Received | sed -n '1p;$p'
kubectl logs  `kubectl get po | grep source | cut -f 1 -d ' '` | grep -e Successfully | sed -n '1p;$p'

# Monitoring rabbitmq status
watch -n 0.1 docker exec -it rabbitmq rabbitmqctl list_queues
```
