import Foundation

let defaultBaseURL = "http://localhost:8080"

func get(_ urlString: String) {
    guard let url = URL(string: urlString) else {
        print("invalid URL")
        return
    }

    let semaphore = DispatchSemaphore(value: 0)

    var responseData: Data?
    var response: URLResponse?
    var error: Error?

    URLSession.shared.dataTask(with: url) { data, resp, err in
        responseData = data
        response = resp
        error = err
        semaphore.signal()
    }.resume()

    semaphore.wait()

    if let err = error {
        print("request failed: \(err)")
        return
    }

    if let http = response as? HTTPURLResponse {
        print("status: \(http.statusCode)")
    }

    if let data = responseData,
       let body = String(data: data, encoding: .utf8) {
        print(body)
    }
}

@main
struct StatelessSwiftClient {
    static func main() {
        let args = CommandLine.arguments

        if args.count < 2 {
            print("usage:")
            print("  swift-client health [baseURL]")
            print("  swift-client hello [name] [baseURL]")
            print("  swift-client fib [n] [baseURL]")
            return
        }

        let command = args[1]

        switch command {
        case "health":
            let baseURL = args.count >= 3 ? args[2] : defaultBaseURL
            get("\(baseURL)/health")

        case "hello":
            let name = args.count >= 3 ? args[2] : "world"
            let baseURL = args.count >= 4 ? args[3] : defaultBaseURL
            get("\(baseURL)/?name=\(name)")

        case "fib":
            let n = args.count >= 3 ? args[2] : "35"
            let baseURL = args.count >= 4 ? args[3] : defaultBaseURL
            get("\(baseURL)/fib?n=\(n)")

        default:
            print("unknown command: \(command)")
        }
    }
}