output "dynamodb_table_name" {
  value = aws_dynamodb_table.user_info.name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.oma_automation_bucket.id
}

output "api_user_name" {
  value = aws_iam_user.api_user.name
}

output "secrets_manager_secret_name" {
  value = aws_secretsmanager_secret.api_keys.name
}

