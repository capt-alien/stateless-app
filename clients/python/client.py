import sys
import requests

SERVICES = {
    "go": "http://localhost:8080",
    "swift": "http://localhost:8081",
    "python": "http://localhost:8082",
}

def get(url):
    try:
        resp = requests.get(url, timeout=5)
        print(f"status: {resp.status_code}")
        print(resp.text)
    except requests.RequestException as err:
        print(f"request failed: {err}")
        sys.exit(1)

def usage():
    print("usage:")
    print("  python client.py health [go|swift|python]")
    print("  python client.py hello <name> [go|swift|python]")
    print("  python client.py fib <n> [go|swift|python]")

def get_service(name):
    return SERVICES.get(name, SERVICES["go"])

def main():
    if len(sys.argv) < 2:
        usage()
        sys.exit(1)

    command = sys.argv[1]

    if command == "health":
        target = sys.argv[2] if len(sys.argv) >= 3 else "go"
        base_url = get_service(target)
        get(f"{base_url}/health")

    elif command == "hello":
        name = sys.argv[2] if len(sys.argv) >= 3 else "world"
        target = sys.argv[3] if len(sys.argv) >= 4 else "go"
        base_url = get_service(target)
        get(f"{base_url}/?name={name}")

    elif command == "fib":
        n = sys.argv[2] if len(sys.argv) >= 3 else "35"
        target = sys.argv[3] if len(sys.argv) >= 4 else "go"
        base_url = get_service(target)
        get(f"{base_url}/fib?n={n}")

    else:
        print(f"unknown command: {command}")
        usage()
        sys.exit(1)

if __name__ == "__main__":
    main()