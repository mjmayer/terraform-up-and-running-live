provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    key            = "stage/data-stores/mysql/terraform.tfstate"
    bucket         = "terraform-up-and-running-state-mjmayer"
    region         = "us-west-2"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

module "mysql" {
  source = "../../../modules/data-stores/mysql"

  cluster_name = "mysql-stage"
  # db_remote_state_bucket = "terraform-up-and-running-state-mjmayer"
  # db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"
}
