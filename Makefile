CLUSTER_NAME=migration-lab

# ------------------------
# LOCAL
# ------------------------

start-local:
	kind create cluster --name $(CLUSTER_NAME)

destroy-local:
	kind delete cluster --name $(CLUSTER_NAME)

build-go:
	docker build -t go-server:latest .

build-swift:
	docker build -t swift-server:latest ./services/swift

build-local:
	make build-go
	make build-swift

load-local:
	kind load docker-image go-server:latest --name $(CLUSTER_NAME)
	kind load docker-image swift-server:latest --name $(CLUSTER_NAME)

deploy-local:
	kubectl apply -k k8s/base

restart-local:
	kubectl rollout restart deployment go-server
	kubectl rollout restart deployment swift-server
	kubectl rollout restart deployment envoy

forward-local:
	kubectl port-forward svc/envoy-lb 8080:80

up-local:
	make build-local
	make load-local
	make deploy-local
	make restart-local

down-local:
	kubectl delete -k k8s/base

status-local:
	kubectl get pods
	kubectl get svc

metrics-local:
	curl localhost:8080/go/metrics
	curl localhost:8080/swift/metrics

watch-local:
	kubectl get pods -w


# ------------------------
# AWS
# ------------------------

build-aws:
	echo "TODO ECR build"

deploy-aws:
	tofu apply

up-aws:
	make build-aws
	make deploy-aws

down-aws:
	tofu destroy


# ------------------------
# GCP
# ------------------------

build-gcp:
	echo "TODO Artifact Registry build"

deploy-gcp:
	echo "TODO GKE deploy"

up-gcp:
	make build-gcp
	make deploy-gcp

down-gcp:
	echo "TODO GKE destroy"