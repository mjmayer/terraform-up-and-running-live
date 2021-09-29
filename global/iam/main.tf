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

resource "aws_iam_policy" "cloudwatch_read_only" {
  name   = "cloudwatch-read-only"
  policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}

data "aws_iam_policy_document" "cloudwatch_read_only" {
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatch_full_accss" {
  name   = "cloudwatch-full-access"
  policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}

data "aws_iam_policy_document" "cloudwatch_full_access" {
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy_attachment" "neo_cloudwatch_full_access" {
  count = var.give_neo_cloudwatch_full_access ? 1 : 0

  user       = aws_iam_user.example["neo"].name
  policy_arn = aws_iam_policy.cloudwatch_full_accss.arn
}

resource "aws_iam_user_policy_attachment" "neo_cloudwatch_read_access" {
  count = var.give_neo_cloudwatch_full_access ? 0 : 1

  user       = aws_iam_user.example[0].name
  policy_arn = aws_iam_policy.cloudwatch_read_only.arn

}
