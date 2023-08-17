

variable "number_of_azs" {
    type = number
    default = 2
}

variable "vpc_cidr1" {
    type = string
    default = "10.0.0.0/16"
  
}

variable "vpc_tags" {
    type = list(string)
    default = [ "public-subnet", "private-subnet", "public-subnet1", "private-subnet1" ]
  
}