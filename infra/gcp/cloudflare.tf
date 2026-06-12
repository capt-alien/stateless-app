resource "cloudflare_record" "gcp_stateless_app" {
  zone_id = var.cloudflare_zone_id
  name    = "gcp"
  type    = "A"
  content = var.gcp_lb_ip
  ttl     = 60
  proxied = false
}

resource "cloudflare_record" "gcp_grafana" {
  zone_id = var.cloudflare_zone_id
  name    = "grafana"
  type    = "A"
  content = var.gcp_lb_ip
  ttl     = 60
  proxied = false
}