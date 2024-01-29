# rabbitmq-source-demo

## Quick Start
- Install
  - Replace x.x.x.x to IP address of your host
```bash
make all-minikube IP=x.x.x.x
# or
make all-kind IP=x.x.x.x
```

- Push 500 requests to RabbitMQ
```bash
make req N=500
```

- help
```bash
make help
```

## Verify
```sh
# Confirm that 500 fn are activated
kubectl logs `kubectl get po | grep event-display | cut -f 1 -d ' '` | grep UTC | wc -l
kubectl logs `kubectl get po | grep event-display | cut -f 1 -d ' '` | grep UTC | sed -n '1p;$p'

# Number of requests received by source
kubectl logs  `kubectl get po | grep rabbitmqsource | cut -f 1 -d ' '` | grep -e Received | wc -l
kubectl logs  `kubectl get po | grep rabbitmqsource | cut -f 1 -d ' '` | grep -e Successfully | wc -l

# Time difference between first and last request
kubectl logs  `kubectl get po | grep rabbitmqsource | cut -f 1 -d ' '` | grep -e Received | sed -n '1p;$p'
kubectl logs  `kubectl get po | grep rabbitmqsource | cut -f 1 -d ' '` | grep -e Successfully | sed -n '1p;$p'

# Monitoring rabbitmq status
watch -n 0.1 docker exec -it rabbitmq rabbitmqctl list_queues
```


## Build event-display & push container registry
```sh
# pwd: knative-source/event-display
./build [container registry]
cd ../
# Please specify the container registry in spec.template.spec.container[].image in service.yml
```