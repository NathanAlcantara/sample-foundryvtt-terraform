provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "foundryvtt-rpg-terraform-state"

  lifecycle {
    prevent_destroy = true
  }
}

module "compute" {
  source              = "./modules/compute"
  vpc_id              = module.network.vpc_id
  public_subnet_id    = element(module.network.public_subnets, 0)
  foundry_int_type    = var.foundry_int_type
  foundry_volume_size = var.foundry_volume_size
  foundry_key         = module.iam.key
  foundry_secret      = module.iam.secret
  foundry_domain_name = var.foundry_domain_name
}

module "storage" {
  source = "./modules/storage"
}

module "network" {
  source                  = "./modules/network"
  foundry_instance_id     = module.compute.foundry_instance_id
  foundry_certificate_arn = module.dns.foundry_certificate_arn
}

module "dns" {
  source              = "./modules/dns"
  foundry_domain_name = var.foundry_domain_name
  alb_zone_id         = module.network.alb_zone_id
  alb_dns_name        = module.network.alb_dns_name
}

module "iam" {
  source             = "./modules/iam"
  foundry_bucket_arn = module.storage.foundry_bucket_arn
}

module "monitoring" {
  source                  = "./modules/monitoring"
  stop_start_ec2_role_arn = module.iam.stop_start_ec2_role_arn
  discord_webhook_url     = var.discord_webhook_url
}
