# knative-source
## インストールと実行
- knative環境の構築
```sh
cd ansible
sudo pip3 install ansible-core==2.12.3
ansible-galaxy collection install community.docker
ansible-galaxy collection install community.general
ansible-galaxy collection install kubernetes.core
# 上記のコマンドは一回実行すればOK
# 下記のコマンドは環境を作り直したいときに都度実行
rm ~/.ssh/known_hosts
ansible-playbook -i inventory.yml -bK play-knative.yml
```
- その他の環境構築
```sh
# Start Rabbitmq container
docker compose up -d
# Build event-display
cd event-display
./build <container registry> # ex) ./build.sh docker.io/shiron228/event-display
cd ../
# Apply knative-source & knative-service
./exe.sh
```
- 実行
```sh
# Push 500 requests to Rabbitmq
./client.py 500
```

## 確認
```sh
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
