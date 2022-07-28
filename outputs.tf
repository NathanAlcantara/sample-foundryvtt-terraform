output "foundry_dns" {
  value = module.compute.public_dns
}

output "foundry_ip" {
  value = module.compute.public_ip
}
