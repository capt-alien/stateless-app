CLUSTER_NAME=migration-lab

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
	kubectl port-forward svc/envoy-lb 8080:80

connect-local: forward-local

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


up-aws:
	tofu apply

down-aws:
	tofu destroy


up-gcp:
	echo "TODO"

down-gcp:
	echo "TODO"