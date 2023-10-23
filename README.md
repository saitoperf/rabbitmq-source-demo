# knative-source
```sh
docker compose up -d
kubectl delete -f service.yml ; kubectl delete -f source.yml ; \
kubectl apply -f service.yml && kubectl apply -f source.yml
time ./client.py 500

# 500個のfnが起動していることを確認
kubectl logs  `kubectl get po | grep event-display | cut -f 1 -d ' '` | grep Hello | wc -l
# kubectl logs  `kubectl get po | grep event-display | cut -f 1 -d ' '` | grep UTC | sed -n '1p;$p'
kubectl logs -l app=event-display-00001 | grep UTC | sed -n '1p;$p'

# sourceが受け取ったリクエストの数
kubectl logs  `kubectl get po | grep source | cut -f 1 -d ' '` | grep -e Received | wc -l
kubectl logs  `kubectl get po | grep source | cut -f 1 -d ' '` | grep -e Successfully | wc -l

# 最初と最後のリクエストの時間差
kubectl logs  `kubectl get po | grep source | cut -f 1 -d ' '` | grep -e Received | sed -n '1p;$p'
kubectl logs  `kubectl get po | grep source | cut -f 1 -d ' '` | grep -e Successfully | sed -n '1p;$p'

# rabbitmqの状態の確認
docker exec -it rabbitmq rabbitmqctl list_queues
```
