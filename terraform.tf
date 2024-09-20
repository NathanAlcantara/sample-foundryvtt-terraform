terraform {
  required_version = "~> 1.8"

  backend "s3" {
    bucket                   = "foundryvtt-rpg-terraform-state"
    key                      = "prod/terraform.tfstate"
    region                   = "us-east-1"
    encrypt                  = true
    shared_credentials_files = ["~/.aws/credentials"]
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.68.0"
    }
    archive = {
      source = "hashicorp/archive"
      version = "2.4.2"
    }
  }
}
