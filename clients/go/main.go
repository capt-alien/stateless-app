package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
)

const defaultBaseURL = "http://44.243.202.146:8080"

func main() {
	baseURL := flag.String("url", defaultBaseURL, "base URL for stateless-app server")
	name := flag.String("name", "world", "name to send to hello endpoint")

	flag.Parse()

	if flag.NArg() < 1 {
		usage()
		os.Exit(1)
	}

	command := flag.Arg(0)

	switch command {
	case "hello":
		callEndpoint(fmt.Sprintf("%s/?name=%s", *baseURL, *name))
	case "health":
		callEndpoint(fmt.Sprintf("%s/health", *baseURL))
	default:
		fmt.Println("unknown command:", command)
		usage()
		os.Exit(1)
	}
}

func callEndpoint(url string) {
	resp, err := http.Get(url)
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()

	var data map[string]string
	if err := json.NewDecoder(resp.Body).Decode(&data); err != nil {
		log.Fatal(err)
	}

	for k, v := range data {
		fmt.Printf("%s: %s\n", k, v)
	}
}

func usage() {
	fmt.Println("usage:")
	fmt.Println("  stateless health")
	fmt.Println("  stateless hello --name eric")
	fmt.Println("  stateless --url http://host:8080 health")
}