# Build stage
FROM golang:1.22-alpine AS builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o stateless-app ./cmd/server

# Runtime stage
FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/stateless-app .

EXPOSE 8080

CMD ["./stateless-app"]