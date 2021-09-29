provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "remote" {
    organization = "ucdavis"
    workspaces {
      name = "terraform-up-and-running-services-webserver-cluster-prod"
    }
  }
}
module "webserver_cluster" {
  source = "github.com/mjmayer/terraform-up-and-running-modules//modules/services/webserver-cluster?ref=v0.0.14"

  cluster_name           = "webservers-prod"
  db_remote_state_bucket = "terraform-up-and-running-state-mjmayer"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

  instance_type = "m4.large"
  min_size      = 2
  max_size      = 10
  enable_autoscaling = true
  enable_new_user_data = false

  custom_tags = {
    Owner      = "team-foo"
    DeployedBy = "terraform"
  }
}

