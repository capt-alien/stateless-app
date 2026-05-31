resource "cloudflare_record" "aws_stateless_app" {
  zone_id = var.cloudflare_zone_id
  name    = "aws"
  type    = "CNAME"
  content = var.aws_lb_hostname
  ttl     = 60
  proxied = false
}