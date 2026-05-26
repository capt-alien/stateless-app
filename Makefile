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


up-aws:
	tofu apply

down-aws:
	tofu destroy


up-gcp:
	echo "TODO"

down-gcp:
	echo "TODO"