import Vapor

let app = try Application(.detect())
defer { app.shutdown() }

app.http.server.configuration.hostname = "0.0.0.0"
app.http.server.configuration.port = 8081

app.get("health") { req async throws -> [String: String] in
    return [
        "status": "healthy"
    ]
}

app.get { req async throws -> [String: String] in
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