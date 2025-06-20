resource "aws_instance" "osticket" {
  ami             = var.aws_ami_id
  instance_type   = var.aws_instance_type
  security_groups = [aws_security_group.osticker.name]
  key_name        = aws_key_pair.deployer.key_name
  # user_data       = file("scripts/install-docker-engine.sh") # Path to your user data script for initial setup
  tags = {
    Name = var.aws_instance_name
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.deployer_ssh_public_key
}