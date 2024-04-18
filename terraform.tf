terraform {
  cloud {
    organization = "Thanak_Cloud_Resume_Challenge"
    workspaces {
      name = "resume-challenge"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31.0"
    }
  }

  required_version = "~> 1.2"
}

provider "aws" {
  shared_config_files = [var.tfc_aws_dynamic_credentials.default.shared_config_file]
  region              = var.region
}