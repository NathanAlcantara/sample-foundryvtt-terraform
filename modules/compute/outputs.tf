output "foundry_instance_id" {
  value = module.ec2_instance.id
}
output "foundry_public_ip" {
  value = module.ec2_instance.public_ip
}
