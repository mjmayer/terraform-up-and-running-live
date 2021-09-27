provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    key            = "prod/data-stores/mysql/terraform.tfstate"
    bucket         = "terraform-up-and-running-state-mjmayer"
    region         = "us-west-2"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}
module "mysql" {
  source = "github.com/mjmayer/terraform-up-and-running-modules//modules/data-stores/mysql?ref=v0.0.2"

  cluster_name = "mysql-prod"
}
