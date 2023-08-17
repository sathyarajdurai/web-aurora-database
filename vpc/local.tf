locals {
  vpc_public_tag = "public-subnet1"
  vpc_private_tag = "private-subnet"

  availability-zones = slice(data.aws_availability_zones.available.names, 0, var.number_of_azs)

  public_subnet_cidr   = cidrsubnet(var.vpc_cidr1, 7, 8)
  private_subnet_cidr  = cidrsubnet(var.vpc_cidr1, 5, 3)
  database_subnet_cidr = cidrsubnet(local.private_subnet_cidr, 3, 2)
  # redshift_subnet_cidr = cidrsubnet(var.vpc_cidr, 7, 5)
  account_id = data.aws_caller_identity.id.account_id
  
}