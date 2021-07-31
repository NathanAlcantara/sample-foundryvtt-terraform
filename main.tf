terraform {
  required_version = ">= 0.13"

  backend "s3" {
    bucket  = "foundry-rpg-terraform-state"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/creds"
  profile                 = "default"
}

module "compute" {
  source           = "./modules/compute"
  foundry_int_type = var.foundry_int_type
  foundry_key      = module.iam.key
  foundry_secret   = module.iam.secret
}

module "storage" {
  source           = "./modules/storage"
}

module "iam" {
  source             = "./modules/iam"
  foundry_bucket_arn = module.storage.foundry_bucket_arn
}