output "foundry_dns_name_servers" {
  value = aws_route53_zone.foundry_hosted_zone.name_servers
}

output "foundry_certificate_arn" {
  value = module.acm.acm_certificate_arn
}
