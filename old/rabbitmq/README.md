# knative-source
## インストールと実行
- knative環境の構築
```sh
# localhostに公開鍵認証できるようにする
ssh-keygen
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys 
rm ~/.ssh/known_hosts
# install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
# install ansible
sudo apt update
sudo apt install pipx
pipx install ansible-core==2.15.5
pipx install pika
ansible-galaxy collection install community.docker
ansible-galaxy collection install community.general
ansible-galaxy collection install kubernetes.core
# 上記のコマンドは一回実行すればOK
# 下記のコマンドは環境を作り直したいときに都度実行
# knative-source/rabbitmq/ansible
ansible-playbook -i inventory.yml -bK deploy_minikube.yml
```
- rabbitmq関連
```sh
# Start Rabbitmq container
# pwd: knative-source/rabbitm
docker compose up -d
```
- その他の環境構築 (pwd: knative-source)
```sh
# Build event-display & push container registry
cd event-display
./build <container registry> # ex) ./build.sh docker.io/shiron228/event-display
cd ../
# ここで、service.ymlのspec.template.spec.container[].imageにコンテナレジストリを指定してください！
# Apply knative-source & knative-service
./exe.sh    # secretの「--from-literal=uri=192.168.2.12」を自分のIPに編集する
```
- 実行
```sh
# Push 500 requests to Rabbitmq
./client.py 500
```

## 確認
```sh
# 500個のfnが起動していることを確認
kubectl logs `kubectl get po | grep event-display | cut -f 1 -d ' '` | grep UTC | wc -l
kubectl logs `kubectl get po | grep event-display | cut -f 1 -d ' '` | grep UTC | sed -n '1p;$p'
# kubectl logs -l app=event-display-00001 | grep UTC | sed -n '1p;$p'

# sourceが受け取ったリクエストの数(どっちも同じ)
kubectl logs  `kubectl get po | grep source | cut -f 1 -d ' '` | grep -e Received | wc -l
kubectl logs  `kubectl get po | grep source | cut -f 1 -d ' '` | grep -e Successfully | wc -l

# 最初と最後のリクエストの時間差
kubectl logs  `kubectl get po | grep source | cut -f 1 -d ' '` | grep -e Received | sed -n '1p;$p'
kubectl logs  `kubectl get po | grep source | cut -f 1 -d ' '` | grep -e Successfully | sed -n '1p;$p'

# rabbitmqの状態の監視
watch -n 0.1 docker exec -it rabbitmq rabbitmqctl list_queues
```
