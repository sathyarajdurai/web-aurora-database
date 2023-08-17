

data "aws_availability_zones" "available" {

  state = "available"
}

data "aws_key_pair" "cloud_key" {
  key_name           = "cloud-key"
  include_public_key = true
}


data "aws_caller_identity" "id" {
  # provider = "eu-west-1"
}




