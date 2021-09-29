provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "remote" {
    organization = "ucdavis"
    workspaces {
      name = "terraform-up-and-running-data-stores-mysql-stage"
    }
  }
}

module "mysql" {
  source = "github.com/mjmayer/terraform-up-and-running-modules//modules/data-stores/mysql?ref=v0.0.2"

  cluster_name = "mysql-stage"
  # db_remote_state_bucket = "terraform-up-and-running-state-mjmayer"
  # db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"
}
