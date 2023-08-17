resource "aws_instance" "web_server" {
  # depends_on                  = [aws_network_interface.migrate_web]
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = "t2.small"
  key_name             = data.aws_key_pair.cloud_key.key_name
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  subnet_id            = data.aws_subnet.public.id
  security_groups      = [aws_security_group.web_server_db.id]
  #   private_dns_name_options {
  #     enable_resource_name_dns_a_record = true
  #   }
  associate_public_ip_address = true
  user_data                   = file("${path.module}/webserver.sh")


  tags = {
    Name   = "web-server-lamp"
    Backup = "websever-backup"
  }
}
