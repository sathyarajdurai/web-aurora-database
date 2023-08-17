

resource "aws_security_group" "db_sg" {
  name        = "web-db-sg"
  description = "Allow db inbound traffic"
  vpc_id      = data.aws_vpc.cloud.id

  ingress {
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "db port"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [data.aws_security_group.wsdb_server.id]

  }

  egress {
    description      = "default"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "webserver-db-sg"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "webserver-subnet-group"
  subnet_ids = [data.aws_subnet.database_subnet.id, data.aws_subnet.database_subnet1.id]

  # tags = {
  #   Name = "My DB subnet group"
  # }
}

resource "aws_rds_cluster" "web_rds" {
  # count = 2
  cluster_identifier          = "webrdsaurora"
  availability_zones          = ["eu-west-1a", "eu-west-1b", "eu-west-1c"] #local.availability-zones #  data.aws_availability_zones.available.names[count.index]   
  engine                      = "aurora-mysql"
  engine_version              = "8.0"
  db_subnet_group_name        = aws_db_subnet_group.rds_subnet_group.name
  database_name               = "auroratest"
  backup_retention_period     = 5
  manage_master_user_password = true
  master_username             = "webdbtest"
  vpc_security_group_ids      = [aws_security_group.db_sg.id]
  skip_final_snapshot         = true
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "aurora-cluster-demo-${count.index}"
  cluster_identifier = aws_rds_cluster.web_rds.cluster_identifier
  instance_class     = "db.t3.medium"
  engine             = aws_rds_cluster.web_rds.engine
  engine_version     = aws_rds_cluster.web_rds.engine_version
}
