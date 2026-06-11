# Stateless App

A cloud-native platform engineering project demonstrating multi-language services deployed to Kubernetes using OpenTofu, Envoy, Cloudflare DNS, and managed cloud infrastructure.

## Live Environment

### GCP Deployment

Platform:
- Google Kubernetes Engine (GKE)
- Envoy Proxy
- Cloudflare DNS
- OpenTofu Infrastructure as Code

URL:
- http://gcp.captalien.io

### Endpoints

Go Service:
- http://gcp.captalien.io/go
- http://gcp.captalien.io/go/fib?n=10
- http://gcp.captalien.io/go/metrics

Swift Service:
- http://gcp.captalien.io/swift
- http://gcp.captalien.io/swift/fib?n=10
- http://gcp.captalien.io/swift/metrics

---

## Architecture

Internet
    |
    v
Cloudflare DNS
    |
    v
GCP Load Balancer
    |
    v
Envoy Proxy
    ├── /go     → Go Service
    └── /swift  → Swift Service

Components:
- Go HTTP service
- Swift HTTP service
- Envoy reverse proxy
- Kubernetes
- OpenTofu
- Cloudflare DNS
- Prometheus metrics endpoints

---

## Repository Layout

clients/
├── go/
├── python/
└── swift/

infra/
├── aws/
└── gcp/

k8s/
├── base/
└── overlays/

monitoring/

services/
├── go/
├── python/
└── swift/

---

## Environment Setup

Create local environment file:

make env-set

---

## Local Kubernetes Deployment

Deploy services:

make up-local

Port-forward Envoy:

make forward-local

Test services:

make test-local

View status:

make status-local

View logs:

make logs-local

View metrics:

make metrics-local

Destroy deployment:

make down-local

---

## Kubernetes Context Management

Switch to local Kind cluster:

make context-local

Switch to AWS cluster:

make context-aws

Switch to GCP cluster:

make context-gcp

---

## AWS Deployment

Plan infrastructure:

make plan-aws

Create infrastructure:

make up-aws

Deploy workloads:

make deploy-aws

Configure DNS:

make dns-aws

View cluster status:

make status-aws

View pods and services:

make pods-aws

View Terraform outputs:

make outputs-aws

Destroy infrastructure:

make down-aws

---

## GCP Deployment

Plan infrastructure:

make plan-gcp

Create infrastructure:

make up-gcp

This performs:
- OpenTofu apply
- GKE credential download
- Kubernetes context setup

Deploy workloads:

make deploy-gcp

This deploys:
- Go service
- Swift service
- Envoy proxy
- Kubernetes services

Configure DNS:

make dns-gcp

This waits for the GCP LoadBalancer IP and updates Cloudflare automatically.

View cluster status:

make status-gcp

View pods and services:

make pods-gcp

View outputs:

make outputs-gcp

Destroy infrastructure:

make down-gcp

---

## Useful Kubernetes Commands

Current context:

kubectl config current-context

View nodes:

kubectl get nodes

View pods:

kubectl get pods

View services:

kubectl get svc

View all resources:

kubectl get all

Restart Envoy:

kubectl rollout restart deployment/envoy

Restart Go service:

kubectl rollout restart deployment/go-server

Restart Swift service:

kubectl rollout restart deployment/swift-server

---

## Load Testing

Install hey:

brew install hey

Run tests:

hey -n 1000 -c 25 http://gcp.captalien.io/go

hey -n 1000 -c 25 http://gcp.captalien.io/swift

hey -n 100 -c 10 "http://gcp.captalien.io/go/fib?n=35"

hey -n 100 -c 10 "http://gcp.captalien.io/swift/fib?n=35"

Monitor cluster during testing:

kubectl top pods

kubectl top nodes

---

## Current Features

- Multi-language services (Go and Swift)
- Envoy path-based routing
- Recursive Fibonacci workload endpoint
- Prometheus-compatible metrics
- Cloudflare DNS automation
- OpenTofu infrastructure provisioning
- AWS EKS deployment
- GCP GKE deployment
- Kubernetes context automation
- Public cloud deployment URL

---

## Next Steps

### Observability

- Deploy Prometheus to GKE
- Deploy Grafana to GKE
- Expose Grafana at grafana.captalien.io
- Create service dashboards
- Build latency visualizations
- Add alerting

### OpenTelemetry

- Deploy OTel Collector
- Instrument Go service
- Instrument Swift service
- Add distributed tracing
- Evaluate Tempo or Jaeger

### Platform Engineering

- Automated container builds
- CI/CD pipeline
- Authentication layer
- Horizontal Pod Autoscaling
- Multi-cloud failover
- Canary deployments

---

## Learning Goals

This project is intended to demonstrate practical experience with:

- Site Reliability Engineering (SRE)
- Kubernetes
- Platform Engineering
- Infrastructure as Code
- OpenTofu / Terraform
- Cloud Networking
- Envoy
- Cloudflare DNS
- Observability
- OpenTelemetry
- Multi-cloud Deployments
- Production Operations



Current State:
- Envoy admin interface exposed for observability lab work

Future Improvements:
- Move Envoy admin endpoint to internal-only ClusterIP service
- Add authentication
- Restrict access with NetworkPolicies