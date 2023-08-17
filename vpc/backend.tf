terraform {
  backend "s3" {
    bucket         = "talent-academy-sathyaraj-lab-tfstates-june"
    key            = "talent-academy/web-database-vpc/terraform.tfstates"
    dynamodb_table = "terraform-lock"
  }
}