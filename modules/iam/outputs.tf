output "key" {
  value = aws_iam_access_key.foundry_user.id
}

output "secret" {
  value = aws_iam_access_key.foundry_user.secret
}

output "stop_start_ec2_role_arn" {
  value = aws_iam_role.stop_start_ec2_role.arn
}
