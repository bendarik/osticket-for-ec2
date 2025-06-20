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

module "aws_module" {
  source = "./aws-module"

  aws_region              = var.aws_region
  cloudflare_api_token    = var.cloudflare_api_token
  cloudflare_zone_id      = var.cloudflare_zone_id
  domain_name             = var.domain_name
  deployer_ssh_public_key = var.deployer_ssh_public_key
}

output "aws_instance_public_ip" {
  value = module.aws_module.aws_instance_public_ip  
}

output "aws_instance_public_dns" {
  value = module.aws_module.aws_instance_public_dns
}