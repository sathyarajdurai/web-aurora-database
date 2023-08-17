resource "aws_security_group" "web_server_db" {
  name        = "webserver-sg"
  description = "Allow inbound traffic"
  vpc_id      = data.aws_vpc.web_db.id

  dynamic "ingress" {
    for_each = var.port
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    
  }

  # ingress {
  #   description = "http from VPC"
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   # security_groups = [aws_security_group.lb_internet_face.id]

  # }

  # ingress {
  #   description = "https from VPC"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   # security_groups = [aws_security_group.lb_internet_face.id]
  # }

  # ingress {
  #   description = "ssh from VPC"
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   # security_groups = [aws_security_group.lb_internet_face.id]
  # }

  egress {
    description      = "default"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "webserver-sg"
  }
}
