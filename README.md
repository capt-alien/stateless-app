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
1) deploy app on AWS
2) Create auth methods
3) create a go client
4) create swift app
5) create swift client
6) create a paralell deployment with envoy load ballancer that will route based on client
7) Deploy using Terraform or tofu
8) Deploy on GCP
9) deploy on Asure
10) setup TF to deply servers on any cloud
11) ccreate simple Python SDK for client apps. 