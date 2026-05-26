package metrics

import (
	"github.com/prometheus/client_golang/prometheus"
)

var Requests = prometheus.NewCounterVec(
	prometheus.CounterOpts{
		Name: "go_requests_total",
		Help: "Total requests",
	},
	[]string{"path"},
)

func Init() {
	prometheus.MustRegister(Requests)
}