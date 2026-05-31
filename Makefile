# Setup
ifneq (,$(wildcard .env))
include .env
export
endif

CLUSTER_NAME ?= migration-lab

env-set:
	cp templates/sample.env .env

connect-local:
	$(MAKE) forward-local

# Local Deployment

up-local:
	docker build -t go-server:latest -f services/go/Dockerfile .
	docker build -t swift-server:latest ./services/swift

	kind load docker-image go-server:latest --name $(CLUSTER_NAME)
	kind load docker-image swift-server:latest --name $(CLUSTER_NAME)

	kubectl apply -k k8s/base

	kubectl rollout restart deployment go-server
	kubectl rollout restart deployment swift-server
	kubectl rollout restart deployment envoy

down-local:
	kubectl delete -k k8s/base

forward-local:
	kubectl port-forward --address 0.0.0.0 svc/envoy-lb 8080:80

status-local:
	kubectl get pods
	kubectl get svc

logs-local:
	kubectl logs -f deployment/go-server

metrics-local:
	curl localhost:8080/go/metrics
	curl localhost:8080/swift/metrics

test-local:
	curl localhost:8080/go
	curl localhost:8080/go
	curl localhost:8080/swift
	curl localhost:8080/swift
	curl "localhost:8080/go/fib?n=10"
	curl "localhost:8080/swift/fib?n=10"
	@echo "\n--- Go Metrics ---"
	curl localhost:8080/go/metrics
	@echo "\n--- Swift Metrics ---"
	curl localhost:8080/swift/metrics

# AWS Deployment

plan-aws:
	cd infra/aws && tofu plan

up-aws:
	cd infra/aws && tofu apply

down-aws:
	cd infra/aws && tofu destroy \
		-target=aws_eks_node_group.stateless_app \
		-target=aws_eks_cluster.stateless_app

status-aws: context-aws
	kubectl get nodes
	kubectl get pods -A

outputs-aws:
	cd infra/aws && tofu output

# GCP Deployment

up-gcp:
	echo "TODO"

down-gcp:
	echo "TODO"



context-local:
	kubectl config use-context kind-$(CLUSTER_NAME)

context-aws:
	kubectl config use-context stateless-app-aws

pods-local: context-local
	kubectl get pods
	kubectl get svc

pods-aws: context-aws
	kubectl get pods
	kubectl get svc