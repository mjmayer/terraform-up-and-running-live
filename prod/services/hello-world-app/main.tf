provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "remote" {
    organization = "ucdavis"
    workspaces {
      name = "terraform-up-and-running-services-hello-world-app-prod"
    }
  }
}
module "app" {
  source = "github.com/mjmayer/terraform-up-and-running-modules//modules/services/hello-world-app?ref=v0.0.41"

  environment = "prd"

  ami         = "ami-090717c950a5c34d3"
  server_text = "This is production"

  instance_type      = "m4.large"
  min_size           = 2
  max_size           = 10
  enable_autoscaling = true

  custom_tags = {
    Owner      = "team-foo"
    DeployedBy = "terraform"
  }
}

