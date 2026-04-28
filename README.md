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