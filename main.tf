terraform {
  required_version = ">= 0.13"
}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/creds"
  profile                 = "default"
}

module "compute" {
  source           = "./modules/compute"
  foundry_int_type = var.foundry_int_type
}

module "storage" {
  source           = "./modules/storage"
}