import Vapor
import Foundation

actor MetricsStore {
    private var requestCounts: [String: Int] = [:]

    func increment(path: String) {
        requestCounts[path, default: 0] += 1
    }

    func render() -> String {
        var body = """
# HELP swift_requests_total Total Swift HTTP requests
# TYPE swift_requests_total counter

"""

        for (path, count) in requestCounts.sorted(by: { $0.key < $1.key }) {
            body += "swift_requests_total{path=\"\(path)\"} \(count)\n"
        }

        return body
    }
}

let metrics = MetricsStore()

let app = try Application(.detect())
defer { app.shutdown() }

app.http.server.configuration.hostname = "0.0.0.0"
app.http.server.configuration.port = 8081

app.get("health") { req async throws -> [String: String] in
    await metrics.increment(path: "/health")
    return ["status": "healthy"]
}

app.get("metrics") { req async throws -> String in
    return await metrics.render()
}

app.get { req async throws -> [String: String] in
    await metrics.increment(path: "/")

    let name = req.query[String.self, at: "name"] ?? "world"

    return [
        "status": "ok",
        "message": "hello \(name) from swift-server",
        "path": req.url.path
    ]
}

func fib(_ n: Int) -> Int {
    if n <= 1 {
        return n
    }

    return fib(n - 1) + fib(n - 2)
}

app.get("fib") { req async throws -> [String: String] in
    await metrics.increment(path: "/fib")

    let n = req.query[Int.self, at: "n"] ?? 35

    if n < 1 || n > 45 {
        throw Abort(.badRequest, reason: "n must be between 1 and 45")
    }

    let start = Date()
    let result = fib(n)
    let duration = Date().timeIntervalSince(start)

    return [
        "status": "ok",
        "task": "fibonacci",
        "n": "\(n)",
        "result": "\(result)",
        "duration": "\(duration)s"
    ]
}

try app.run()