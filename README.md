# stateless-app

A simple stateless Go HTTP service built for cloud deployment practice.

## What it does

- Serves JSON from /
- Provides a /health endpoint
- Logs request IP and route
- Runs locally or in Docker
- Intended for deployment to AWS ECS Fargate, GCP Cloud Run, and Azure Container Apps

## Run locally

bash go run . 

## Test

bash curl localhost:8080 curl localhost:8080/health curl "localhost:8080/?name=eric" 

## Build Docker image

bash docker build -t stateless-app . 

## Run Docker container

bash docker run --rm -p 8080:8080 stateless-app 

## License

MIT



## TODO

1. Add Envoy as a routing layer in front of all services
2. Configure path-based routing (/go, /swift, /python)
3. Add API key authentication at the Envoy layer
4. Route traffic based on headers (e.g. X-Service)
5. Scale the service to handle 10K requests/second
6. Build a load-testing setup that can generate 10K requests/second
7. Add an autoscaling solution
8. Deploy to AWS, Azure, and GCP with one command using Terraform/OpenTofu and Ansible