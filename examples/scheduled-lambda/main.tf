/*
 Ideally, you use S3 + dynamo, but for this example, it's easier to use the local directory.
*/
terraform {
    backend "local" {
      path = "./.tfstate"
    }
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
      }
    }
}

variable "prefix" {
  description = "A prefix to be used for resources created by this module. Lower-case company name is a good choice."
}

variable "deploy_region" {
  description = "The region into which resources should be created. Defaults to `us-east-2`."
  default = "us-east-2"
}

provider "aws" {
  region = var.deploy_region
  assume_role {
    policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  }
}

module "scheduled-lambda" {
  source = "github.com/atheken/terraform-building-blocks//scheduled-lambda?ref=2022-11-08"
  architecture = "arm64"
  name = "${var.prefix}_example_cron_job"
  working_dir = "./cron-job-container"
  execution_concurrency = -1
  command = ["cron.job"]
  cron_schedules = ["cron(5 * * * ? *)"]
}