output "foundry_public_ip" {
  value = module.compute.foundry_public_ip
}

output "foundry_dns_name_servers" {
  value = module.dns.foundry_dns_name_servers
}
