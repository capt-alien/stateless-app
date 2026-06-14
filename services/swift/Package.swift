// File: services/swift/Package.swift

// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "swift-server",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),

        .package(
            url: "https://github.com/open-telemetry/opentelemetry-swift-core.git",
            from: "2.4.1"
        ),

        .package(
            url: "https://github.com/open-telemetry/opentelemetry-swift.git",
            from: "2.4.1"
        )
    ],
    targets: [
        .executableTarget(
            name: "swift-server",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "OpenTelemetryApi", package: "opentelemetry-swift-core"),
                .product(name: "OpenTelemetrySdk", package: "opentelemetry-swift-core"),
                .product(name: "OpenTelemetryProtocolExporterHTTP", package: "opentelemetry-swift")
            ]
        )
    ]
)