output "public_subnets" {

    value = module.vpc.public_subnets[0]

}