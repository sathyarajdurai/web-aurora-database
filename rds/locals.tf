locals {
    name = jsondecode(data.aws_secretsmanager_secret_version.by_value.secret_string)["username"]
    pass = jsondecode(data.aws_secretsmanager_secret_version.by_value.secret_string)["password"]
    port     = "3306"
    host     = element(split(":",aws_rds_cluster.web_rds.endpoint), 0)
#     host     = aws_rds_cluster.web_rds.add
     availability-zones = slice(data.aws_availability_zones.available.names, 0, var.number_of_azs)
}