resource "cloudflare_dns_record" "dns_record_www" {
  zone_id = var.cloudflare_zone_id
  name    = "www.${var.domain_name}"
  ttl     = 3600
  type    = "A"
  content = aws_instance.osticket.public_ip
  proxied = false
}

resource "cloudflare_dns_record" "dns_record_root" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain_name
  ttl     = 3600
  type    = "A"
  content = aws_instance.osticket.public_ip
  proxied = false
}