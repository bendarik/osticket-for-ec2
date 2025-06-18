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


# Resources

resource "aws_instance" "osticket" {
  ami           = "ami-042b4708b1d05f512"
  instance_type = "t3.micro"
  tags = {
    Name = "osticket_instance"
  }
}

resource "cloudflare_dns_record" "dns_record_root" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain_name
  ttl     = 3600
  type    = "A"
  content = aws_instance.osticket.public_ip
  proxied = false
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
