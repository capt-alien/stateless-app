# stateless-app

`stateless-app` is a multi-service migration and observability lab designed to test application portability across local Kubernetes, AWS, and GCP environments.

The project currently contains:

- Go HTTP service
- Swift HTTP service
- Envoy proxy for routing
- Prometheus-compatible metrics
- Kubernetes deployment manifests
- Multi-language load clients
- External monitoring integration (Prometheus/Grafana on `ub1`)

---

## Architecture

Clients
├── Go
├── Python
└── Swift
        │
        ▼
     Envoy
        │
 ┌──────┴──────┐
 │             │
 ▼             ▼
Go Service   Swift Service
        │
        ▼
Prometheus Metrics
        │
        ▼
ub1 Monitoring Stack
(Prometheus + Grafana)

---

## Features

### Go Service

Routes:

- /
- /health
- /fib?n=10
- /metrics

Features:

- JSON API responses
- Request logging
- Fibonacci CPU workload endpoint
- Prometheus metrics

---

### Swift Service

Routes:

- /
- /health
- /fib?n=10
- /metrics

Features:

- Vapor-based API
- Prometheus metrics
- Migration target testing

---

### Envoy

Routes traffic using path-based routing:

/go            → Go service
/go/metrics    → Go metrics

/swift         → Swift service
/swift/metrics → Swift metrics

---

## Repository Layout

stateless-app/

clients/
├── go/
├── python/
└── swift/

services/
├── go/
│   ├── Dockerfile
│   ├── main.go
│   └── metrics/
│
├── python/
│
└── swift/
    ├── Dockerfile
    └── Sources/

k8s/
└── base/
    ├── go.yaml
    ├── swift.yaml
    ├── envoy.yaml
    ├── envoy-config.yaml
    └── kustomization.yaml

templates/
└── sample.env

---

## Requirements

Local development:

- Docker
- kind
- kubectl
- Make
- Python 3
- OpenTofu (future AWS/GCP deployment)

---

## Configuration

Create local environment file:

cp templates/sample.env .env

Example:

APP_HOST=<local_host>

PROM_HOST=<monitoring_host>
PROM_PORT=9090

GRAFANA_HOST=<grafana_host>
GRAFANA_PORT=3000

`.env` is ignored by git.

---

## Local Deployment

Create local cluster:

make up-local

Forward Envoy:

make forward-local

Check status:

make status-local

Run test workload:

make test-local

Remove deployment:

make down-local

---

## Testing

Go:

curl localhost:8080/go
curl localhost:8080/go/health
curl "localhost:8080/go/fib?n=10"
curl localhost:8080/go/metrics

Swift:

curl localhost:8080/swift
curl localhost:8080/swift/health
curl "localhost:8080/swift/fib?n=10"
curl localhost:8080/swift/metrics

---

## Monitoring

Monitoring currently runs externally on `ub1`.

Components:

- Prometheus
- Grafana

Metrics:

go_requests_total
swift_requests_total

Future work will automate monitoring configuration generation.

---

## Future Cloud Targets

Planned deployment targets:

make up-local
make up-aws
make up-gcp

Goal:

Local
  ↓
AWS
  ↓
GCP

with minimal application changes.

---

## TODO

Platform

[x] Add Envoy routing layer
[x] Add path-based routing
[x] Add Prometheus metrics
[x] Create local Kubernetes deployment
[x] Add Makefile automation

Monitoring

[ ] Auto-generate Prometheus configs
[ ] Grafana dashboards
[ ] Alerting
[ ] Migration dashboards

Clients

[ ] Raspberry Pi traffic generators
[ ] Client deployment automation
[ ] Load migration testing

Cloud

[ ] AWS deployment workflow
[ ] GCP deployment workflow
[ ] OpenTofu automation
[ ] Cross-cloud migration testing

Performance

[ ] Load generation
[ ] Autoscaling
[ ] Traffic migration testing
[ ] 10K req/sec validation

---

## License

MIT