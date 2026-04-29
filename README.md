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

1. Build a Swift client and Swift server
2. Configure Envoy to route to each service based on client type
3. Scale the service to handle 10K requests/second
4. Build a load-testing setup that can generate 10K requests/second
5. Add an autoscaling solution
6. Deploy to AWS, Azure, and GCP with one command using Terraform/OpenTofu and Ansible