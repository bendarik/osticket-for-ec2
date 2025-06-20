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