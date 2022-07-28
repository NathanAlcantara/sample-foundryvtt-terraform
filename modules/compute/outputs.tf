output "public_dns" {
  value = aws_instance.foundry.public_dns
}

output "public_ip" {
  value = aws_instance.foundry.public_ip
}
