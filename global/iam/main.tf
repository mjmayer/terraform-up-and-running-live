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

variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["neo", "morpheus"]
}
resource "aws_iam_user" "example" {
  for_each = toset(var.user_names)
  name     = each.value
}
