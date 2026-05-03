from flask import Flask, request, jsonify
import time
import logging

logging.basicConfig(level=logging.INFO)

app = Flask(__name__)

def fib(n):
    if n <= 1:
        return n
    return fib(n - 1) + fib(n - 2)

@app.route("/")
def home():
    name = request.args.get("name", "world")
    return jsonify({
        "status": "ok",
        "message": f"hello {name} from python-server",
        "path": request.path
    })

@app.route("/health")
def health():
    return jsonify({"status": "healthy"})

@app.route("/fib")
def fib_handler():
    n = int(request.args.get("n", 35))

    if n < 1 or n > 45:
        return jsonify({"error": "n must be between 1 and 45"}), 400

    start = time.time()
    result = fib(n)
    duration = time.time() - start

    return jsonify({
        "status": "ok",
        "task": "fibonacci",
        "n": n,
        "result": result,
        "duration": f"{duration}s"
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8082)