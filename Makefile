# Setup
ifneq (,$(wildcard .env))
include .env
export
endif

CLUSTER_NAME ?= migration-lab
GCP_PROJECT_ID ?= stateless-app-498021
GCP_ZONE ?= us-central1-a
GCP_CLUSTER_NAME ?= stateless-app-gke

env-set:
	cp templates/sample.env .env

connect-local:
	$(MAKE) forward-local

###################################################
# Local Deployment
up-local:
	docker build -t go-server:latest -f services/go/Dockerfile .
	docker build -t swift-server:latest ./services/swift
	kind load docker-image go-server:latest --name $(CLUSTER_NAME)
	kind load docker-image swift-server:latest --name $(CLUSTER_NAME)
	kubectl apply -k k8s/base
	kubectl rollout restart deployment/go-server
	kubectl rollout restart deployment/swift-server
	kubectl rollout restart deployment/envoy

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
	curl localhost:8080/swift
	curl "localhost:8080/go/fib?n=10"
	curl "localhost:8080/swift/fib?n=10"
	@echo "\n--- Go Metrics ---"
	curl localhost:8080/go/metrics
	@echo "\n--- Swift Metrics ---"
	curl localhost:8080/swift/metrics

pods-local: context-local
	kubectl get pods
	kubectl get svc

context-local:
	kubectl config use-context kind-$(CLUSTER_NAME)

###################################################
# AWS Deployment
plan-aws:
	cd infra/aws && tofu plan

up-aws:
	cd infra/aws && tofu apply
	aws eks update-kubeconfig \
		--region us-west-2 \
		--name stateless-app-eks \
		--alias stateless-app-aws

deploy-aws: context-aws
	kubectl apply -k k8s/overlays/aws
	kubectl rollout status deployment/go-server
	kubectl rollout status deployment/swift-server
	kubectl rollout status deployment/envoy
	kubectl get pods
	kubectl get svc

dns-aws: context-aws
	$(eval AWS_LB_HOSTNAME := $(shell kubectl get svc envoy-lb -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'))
	@test -n "$(AWS_LB_HOSTNAME)" || (echo "ERROR: envoy-lb hostname not found" && exit 1)
	cd infra/aws && TF_VAR_aws_lb_hostname="$(AWS_LB_HOSTNAME)" tofu apply

down-aws:
	cd infra/aws && tofu destroy \
		-target=aws_eks_node_group.stateless_app \
		-target=aws_eks_cluster.stateless_app

status-aws: context-aws
	kubectl get nodes
	kubectl get pods -A

pods-aws: context-aws
	kubectl get pods
	kubectl get svc

outputs-aws:
	cd infra/aws && tofu output

context-aws:
	kubectl config use-context stateless-app-aws

###################################################
# GCP Deployment
plan-gcp:
	cd infra/gcp && tofu plan

up-gcp:
	cd infra/gcp && tofu apply
	gcloud container clusters get-credentials $(GCP_CLUSTER_NAME) \
		--zone $(GCP_ZONE) \
		--project $(GCP_PROJECT_ID)
	kubectl config rename-context \
		gke_$(GCP_PROJECT_ID)_$(GCP_ZONE)_$(GCP_CLUSTER_NAME) \
		stateless-app-gcp || true
	kubectl config use-context stateless-app-gcp

deploy-gcp: context-gcp
	kubectl apply -k k8s/overlays/gcp
	kubectl rollout status deployment/go-server
	kubectl rollout status deployment/swift-server
	kubectl rollout status deployment/envoy
	kubectl get pods
	kubectl get svc

dns-gcp: context-gcp
	@echo "Waiting for GCP LoadBalancer IP..."
	@while [ -z "$$(kubectl get svc envoy-lb -o jsonpath='{.status.loadBalancer.ingress[0].ip}')" ]; do \
		echo "Still waiting for envoy-lb external IP..."; \
		sleep 5; \
	done
	$(eval GCP_LB_IP := $(shell kubectl get svc envoy-lb -o jsonpath='{.status.loadBalancer.ingress[0].ip}'))
	@echo "Using GCP LoadBalancer IP: $(GCP_LB_IP)"
	cd infra/gcp && TF_VAR_gcp_lb_ip="$(GCP_LB_IP)" tofu apply

down-gcp:
	cd infra/gcp && tofu destroy \
		-target=google_container_node_pool.primary_nodes \
		-target=google_container_cluster.primary

status-gcp: context-gcp
	kubectl get nodes
	kubectl get pods -A

pods-gcp: context-gcp
	kubectl get pods
	kubectl get svc

outputs-gcp:
	cd infra/gcp && tofu output

context-gcp:
	kubectl config use-context stateless-app-gcp

###################################################
# Monitoring

deploy-monitoring-gcp: context-gcp
	kubectl apply -k k8s/monitoring/base
	kubectl rollout status deployment/prometheus
	kubectl get pods
	kubectl get svc

deploy-monitoring-aws: context-aws
	kubectl apply -k k8s/monitoring/base
	kubectl rollout status deployment/prometheus
	kubectl get pods
	kubectl get svc

forward-prometheus-gcp: context-gcp
	kubectl port-forward svc/prometheus 9090:9090

forward-prometheus-aws: context-aws
	kubectl port-forward svc/prometheus 9090:9090

status-monitoring-gcp: context-gcp
	kubectl get pods
	kubectl get svc

status-monitoring-aws: context-aws
	kubectl get pods
	kubectl get svc