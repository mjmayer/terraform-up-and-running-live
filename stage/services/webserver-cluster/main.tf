provider "aws" {
  region = "us-west-2"
}

terraform {
  # backend "s3" {
  #   key            = "stage/services/webserver-cluster/terraform.tfstate"
  #   bucket         = "terraform-up-and-running-state-mjmayer"
  #   region         = "us-west-2"
  #   dynamodb_table = "terraform-up-and-running-locks"
  #   encrypt        = true
  # }
  backend "remote" {
    organization = "ucdavis"
    workspaces {
      name = "terraform-up-and-running-services-webserver-cluster-stage"
    }
  }
}
module "webserver_cluster" {
  source = "github.com/mjmayer/terraform-up-and-running-modules//modules/services/webserver-cluster?ref=v0.0.6"

  cluster_name           = "webservers-stage"
  db_remote_state_bucket = "terraform-up-and-running-state-mjmayer"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

  enable_autoscaling = false

  instance_type = "t3.micro"
  min_size      = 2
  max_size      = 2
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id
  from_port         = 12345
  to_port           = 12345
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
