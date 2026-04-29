package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
)


func homeHandler(w http.ResponseWriter, r *http.Request) {

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

func main() {
	http.HandleFunc("/", homeHandler)
	http.HandleFunc("/health", healthHandler)
	log.Println("starting stateless-app on :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}