module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"

  name = "cloud-migration-vpc"
  cidr = var.vpc_cidr1

  azs              = slice(data.aws_availability_zones.available.names, 0, var.number_of_azs)
  public_subnets   = [for i, v in local.availability-zones : cidrsubnet(local.public_subnet_cidr, 1, i)]
  private_subnets  = [for i, v in local.availability-zones : cidrsubnet(local.private_subnet_cidr, 4, i)]
  # database_subnets = [for i, v in local.availability-zones : cidrsubnet(local.database_subnet_cidr, 1, i)]
  
  
  enable_nat_gateway = true
  single_nat_gateway = true
  map_public_ip_on_launch = true
  private_subnet_tags_per_az = {test = { tes : var.vpc_tags[1], es:var.vpc_tags[3]}}
  # private_subnet_tags = {Name = var.vpc_tags[1], Name = var.vpc_tags[3]}
  # public_subnet_tags = {Name = local.vpc_private_tag}
  
  tags = {
    Terraform   = "true"
  }
}

