terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                   = var.aws_region
  shared_config_files      = ["/Users/aboroufar/.aws/config"]
  shared_credentials_files = ["/Users/aboroufar/.aws/credentials"]
  profile                  = "AdministratorAccess-253906287264"
}