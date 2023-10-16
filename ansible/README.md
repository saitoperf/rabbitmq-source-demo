# ansibleを使った環境構築
```sh
sudo pip3 install ansible-core==2.12.3
ansible-galaxy collection install community.docker
ansible-galaxy collection install community.general
ansible-galaxy collection install kubernetes.core
rm ~/.ssh/known_hosts
ansible-playbook -i inventory.yml -bK play-knative.yml
```
