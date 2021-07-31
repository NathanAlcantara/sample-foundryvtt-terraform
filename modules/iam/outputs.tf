output "key" {
  value = aws_iam_access_key.foundry-user.id
}

output "secret" {
  value = aws_iam_access_key.foundry-user.secret
}