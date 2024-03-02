provider "aws" {
    profile = "default"
    region = var.aws_region

    default_tags {
      tags = {
        Project = var.project_prefix
      }
    }
}

data "aws_region" "current-region" {}