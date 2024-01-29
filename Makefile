.DEFAULT_GOAL := help

.PHONY: help
help: ## 
	@grep -E '^[a-zA-Z0-9_ -]+:.*?## .*$$' $(lastword $(MAKEFILE_LIST)) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}' | sort

.PHONY: kubectl
kubectl: /usr/local/bin/kubectl ## Install kubectl
/usr/local/bin/kubectl:
	curl -LO https://dl.k8s.io/release/v1.29.1/bin/linux/amd64/kubectl
	sudo install kubectl $@
	-mkdir -p $(HOME)/.kube
	-touch $(HOME)/.kube/config
	chmod 600 $(HOME)/.kube/config
	rm kubectl

# https://docs.docker.com/compose/install/linux/#install-the-plugin-manually
DOCKER_CONFIG := $$HOME/.docker
$(DOCKER_CONFIG)/cli-plugins/docker-compose:
	mkdir -p $(DOCKER_CONFIG)/cli-plugins
	curl -SL https://github.com/docker/compose/releases/download/v2.24.2/docker-compose-linux-x86_64 -o $@
	chmod +x $@

.PHONY: all-minikube
all-minikube: kubectl minikube knative certmanager rabbitmq-source rabbitmq rabbitmq-auth service-source ## Install all minikube ver. ex) make all-minikube IP=x.x.x.x

.PHONY: all-kind
all-kind: kubectl kind knative certmanager rabbitmq-source rabbitmq rabbitmq-auth service-source ## Install all kind ver. ex) make all-minikube IP=x.x.x.x

# https://minikube.sigs.k8s.io/docs/start/
/usr/local/bin/minikube:
	cd $$(mktemp -d /tmp/minikube.XXX) && \
	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && \
	sudo install minikube-linux-amd64 $@
	rm -rf /tmp/minikube.*

.PHONY: minikube
minikube: /usr/local/bin/minikube ## Start minikube cluster
	minikube config set memory 25000
	minikube config set cpus 16
	minikube start --kubernetes-version=v1.26.3

# https://kind.sigs.k8s.io/docs/user/quick-start/#installing-with-go-install
/usr/local/bin/kind:
	go install sigs.k8s.io/kind@v0.20.0
	sudo install $$HOME/go/bin/kind $@

.PHONY: kind
kind: /usr/local/bin/kind ## Start kind cluster
	kind create cluster --config kind_config.yml

.PHONY: knative
knative: ## Install knative-serving & knative-eventing
	kubectl apply -f https://github.com/knative/operator/releases/download/knative-v1.12.2/operator.yaml
	kubectl apply -f install/
	kubectl rollout status -n knative-serving deployment
	kubectl rollout status -n knative-eventing deployment

.PHONY: rabbitmq
rabbitmq: $(DOCKER_CONFIG)/cli-plugins/docker-compose ## Start RabbitMQ container
	docker compose up -d

IP := 192.168.1.12
.PHONY: rabbitmq-auth
rabbitmq-auth: ## Create rabbitmq auth. ex) make rabbitmq-auth IP=x.x.x.x
	sed 's/uri: .*/uri: '$(shell echo -n $(IP) | openssl base64)'/' rabbit-auth.yml | kubectl apply -f -

.PHONY: certmanager
certmanager: ## Install cert-manager
	kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.5.4/cert-manager.yaml
	kubectl rollout status -n cert-manager deployment

.PHONY: rabbitmq-source
rabbitmq-source: certmanager ## Install RabbitMQ source
	kubectl apply -f https://github.com/rabbitmq/messaging-topology-operator/releases/download/v1.10.0/messaging-topology-operator-with-certmanager.yaml
	kubectl rollout status -n rabbitmq-system deploy/messaging-topology-operator

.PHONY: service-source
service-source: ## Deploy service & source
	kubectl apply -f service.yml
	kubectl apply -f source.yml

.PHONY: delete-service-source
delete-service-source: ## delete service & source
	kubectl delete -f source.yml
	kubectl delete -f service.yml

/usr/lib/python3/dist-packages/pika/:
	sudo apt install -y python3-pika

N := 500
.PHONY: req
req: /usr/lib/python3/dist-packages/pika/ ## Push # requests to RabbitMQ
	time ./client.py $(N)


.PHONY: delete-minikube
delete-minikube: ## delete minikube cluster
	minikube delete

.PHONY: delete-kind
delete-kind: ## delete kind cluster
	kind delete cluster
