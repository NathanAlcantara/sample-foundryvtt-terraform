# Route53
variable "foundry_domain_name" {
  nullable = false
  type     = string
}

# EC2
variable "foundry_int_type" {}
variable "foundry_volume_size" {}

# Lambda
variable "discord_webhook_url" {
  nullable = false
  type     = string
}
