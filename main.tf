#
# AWS Resources

resource "aws_instance" "osticket" {
  ami             = var.aws_ami_id
  instance_type   = var.aws_instance_type
  security_groups = [aws_security_group.osticker.name]
  key_name        = aws_key_pair.deployer.key_name
  # key_name        = "osticket-key" # Ensure you have created this key pair in AWS
  # user_data       = file("scripts/install-docker-engine.sh") # Path to your user data script for initial setup
  tags = {
    Name = var.aws_instance_name
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.deployer_ssh_public_key
}

resource "aws_security_group" "osticker" {
  name = "osticket-security-group"
}

resource "aws_security_group_rule" "allow_osticket_ssh_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.osticker.id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_osticket_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.osticker.id

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_osticket_https_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.osticker.id

  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_osticket_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.osticker.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1" # All protocols
  cidr_blocks = ["0.0.0.0/0"]
}

#
# Cloudflare DNS Records

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
