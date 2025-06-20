variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "eu-north-1"
}

variable "aws_instance_name" {
  type        = string
  description = "Name of the AWS EC2 instance"
  default     = "osticket"
}

variable "aws_instance_type" {
  type        = string
  description = "AWS instance type for the EC2 instance"
  default     = "t3.micro"
}

variable "aws_ami_id" {
  type        = string
  description = "AWS AMI ID for the EC2 instance"
  default     = "ami-042b4708b1d05f512" # Canonical, Ubuntu, 24.04, amd64 noble image
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token with permissions to manage DNS records"
  sensitive   = true
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare zone ID for the domain"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the DNS record"
}

variable "deployer_ssh_public_key" {
  type        = string
  description = "Public SSH key for the deployer (ubuntu user) to access the EC2 instance"
  sensitive   = true
}
