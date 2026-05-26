package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"

	"stateless-app/services/go/metrics"

	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func homeHandler(w http.ResponseWriter, r *http.Request) {

	metrics.Requests.WithLabelValues(r.URL.Path).Inc()

	hostname, _ := os.Hostname()
	name := r.URL.Query().Get("name")
	if name == "" {
		name = "world"
	}
	clientIP := r.RemoteAddr
	log.Println("request from:", clientIP)

	resp := map[string]string{
		"status":    "ok",
		"message":   "hello " + name,
		"hostname":  hostname,
		"path":      r.URL.Path,
		"method":    r.Method,
		"client_ip": clientIP,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(resp)
}

func healthHandler(w http.ResponseWriter, r *http.Request) {

	metrics.Requests.WithLabelValues(r.URL.Path).Inc()

	clientIP := r.RemoteAddr
	route := r.URL.Path

	log.Printf("health check from %s to %s", clientIP, route)

	resp := map[string]string{
		"status": "healthy",
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	json.NewEncoder(w).Encode(resp)
}

func fibHandler(w http.ResponseWriter, r *http.Request) {

	metrics.Requests.WithLabelValues(r.URL.Path).Inc()

	n := 35

	if nStr := r.URL.Query().Get("n"); nStr != "" {
		parsed, err := strconv.Atoi(nStr)
		if err != nil {
			http.Error(w, "invalid n parameter", http.StatusBadRequest)
			return
		}

		if parsed < 1 || parsed > 45 {
			http.Error(w, "n must be between 1 and 45", http.StatusBadRequest)
			return
		}

		n = parsed
	}

	start := time.Now()

	result := fib(n)

	duration := time.Since(start)

	log.Printf("fib request n=%d duration=%s", n, duration)

	resp := map[string]any{
		"status":   "ok",
		"task":     "fibonacci",
		"n":        n,
		"result":   result,
		"duration": duration.String(),
	}

	w.Header().Set("Content-Type", "application/json")

	json.NewEncoder(w).Encode(resp)
}

func fib(n int) int {
	if n <= 1 {
		return n
	}
	return fib(n-1) + fib(n-2)
}

func main() {

	metrics.Init()

	http.Handle("/metrics", promhttp.Handler())

	http.HandleFunc("/health", healthHandler)
	http.HandleFunc("/fib", fibHandler)

	http.HandleFunc("/", homeHandler)

	log.Println("starting go-server on :8080")

	log.Fatal(http.ListenAndServe(":8080", nil))
}
