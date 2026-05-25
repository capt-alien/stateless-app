FROM swift:6.1-jammy AS builder

WORKDIR /app

COPY Package.swift ./
COPY Package.resolved ./
COPY Sources ./Sources

RUN swift build -c release

FROM ubuntu:22.04

WORKDIR /app

RUN apt-get update && apt-get install -y \
    libatomic1 \
    libicu70 \
    libxml2 \
    libcurl4 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/.build/release/swift-server /app/swift-server

EXPOSE 8081

CMD ["/app/swift-server"]