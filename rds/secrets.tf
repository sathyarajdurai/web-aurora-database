resource "aws_secretsmanager_secret" "aurora_secret" {
  # checkov:skip=BC_AWS_GENERAL_79: ADD REASON by default encryption
  name = "web-rds-secret1"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aurora_new" {
    secret_id     = aws_secretsmanager_secret.aurora_secret.id
    secret_string = <<EOF
   {
                "username": "${local.name}", 
                "password": "${local.pass}", 
                "port": "${local.port}", 
                "host": "${local.host}",
                "engine": "mysql",
                "dbClusterIdentifier": "${aws_rds_cluster.web_rds.cluster_identifier}",
                "dbname": "${aws_rds_cluster.web_rds.database_name}"

   }
EOF
}



