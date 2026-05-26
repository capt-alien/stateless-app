# Build stage
FROM golang:1.23-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
COPY services/go ./services/go

RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o go-server ./services/go

# Runtime stage
FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/go-server /go-server

EXPOSE 8080

CMD ["/go-server"]