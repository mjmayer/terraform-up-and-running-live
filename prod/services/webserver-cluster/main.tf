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
  source = "github.com/mjmayer/terraform-up-and-running-modules//modules/services/webserver-cluster?ref=v0.0.4"

  cluster_name           = "webservers-prod"
  db_remote_state_bucket = "terraform-up-and-running-state-mjmayer"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

  instance_type = "m4.large"
  min_size      = 2
  max_size      = 10

  custom_tags = {
    Owner      = "team-foo"
    DeployedBy = "terraform"
  }
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name  = "scale-out-during-business-hours"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 10
  recurrence             = "0 9 * * *"
  autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name  = "scale-in-at-night"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  recurrence             = "0 17 * * *"
  autoscaling_group_name = module.webserver_cluster.asg_name

}
