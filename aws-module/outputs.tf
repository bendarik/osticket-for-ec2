output "aws_instance_public_ip" {
  description = "Public IP address of the AWS EC2 instance"
  value       = aws_instance.osticket.public_ip
}

output "aws_instance_public_dns" {
  description = "Public DNS name of the AWS EC2 instance"
  value       = aws_instance.osticket.public_dns
}