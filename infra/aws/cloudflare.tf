resource "cloudflare_record" "aws_stateless_app" {
  zone_id = var.cloudflare_zone_id
  name    = "aws"
  type    = "CNAME"
  value   = "a1a18a5d730724b83a79c6f899928400-129417833.us-west-2.elb.amazonaws.com"
  ttl     = 60
  proxied = false
}