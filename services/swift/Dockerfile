FROM swift:6.1-jammy AS builder

WORKDIR /app

COPY Package.swift ./
COPY Package.resolved ./
COPY Sources ./Sources

RUN swift build -c release

FROM swift:6.1-jammy

WORKDIR /app

COPY --from=builder /app/.build/release/swift-server /app/swift-server

EXPOSE 8081

CMD ["/app/swift-server"]