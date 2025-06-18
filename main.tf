terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}


# Variables

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token with permissions to manage DNS records"
  default     = "SYJS4PsoO2JUflBpg-603BiLJJhYHkd_01beGyyS"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare zone ID for the domain"
  default     = "3e0f330a288197b6bf89a7be4084df0e"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the DNS record"
  default     = "baobabka.com"
}


# AWS Resources

resource "aws_instance" "osticket" {
  ami             = "ami-042b4708b1d05f512" # Canonical, Ubuntu, 24.04, amd64 noble image
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.osticker.name]
  key_name        = "osticket-key" # Ensure you have created this key pair in AWS
#   user_data       = file("scripts/install-docker-engine.sh") # Path to your user data script for initial setup
  tags = {
    Name = "osticket-instance"
  }
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
