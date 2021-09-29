provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "remote" {
    organization = "ucdavis"
    workspaces {
      name = "terraform-up-and-running-global-iam"
    }
  }
}

resource "aws_iam_user" "example" {
  count = 3
  name  = "neo.${count.index}"
}
