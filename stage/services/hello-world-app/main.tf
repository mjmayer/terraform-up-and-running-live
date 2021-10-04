provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "remote" {
    organization = "ucdavis"
    workspaces {
      name = "terraform-up-and-running-services-hello-world-app-stage"
    }
  }
}
module "app" {
  source      = "github.com/mjmayer/terraform-up-and-running-modules//modules/services/hello-world-app?ref=v0.0.41"
  environment = "stage"

  ami         = "ami-090717c950a5c34d3"
  server_text = "New server text"

  instance_type      = "t3.micro"
  min_size           = 2
  max_size           = 2
  enable_autoscaling = false
}
