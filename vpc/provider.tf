terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      Env     = "Dev"
      Project = "web-database"
    }
  }
}
