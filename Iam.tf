# IAM User for API
resource "aws_iam_user" "api_user" {
  name = "oma-mirror-api-user-${var.environment}"

  tags = {
    Environment = var.environment
  }
}

# IAM Policy for DynamoDB and S3 access
# resource "aws_iam_policy" "api_policy" {
#   name        = "oma-mirror-api-policy-${var.environment}"
#   description = "Policy for OMA Mirror API access to DynamoDB and S3"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "dynamodb:PutItem",
#           "dynamodb:UpdateItem",
#           "dynamodb:GetItem",
#           "s3:PutObject"
#         ]
#         Resource = [
#           aws_dynamodb_table.user_info.arn,
#           "${aws_s3_bucket.oma_automation_bucket.arn}/*"
#         ]
#       }
#     ]
#   })
# }

resource "aws_iam_policy" "api_policy" {
  name        = "oma-mirror-api-policy-${var.environment}"
  description = "Policy for OMA Mirror API access to DynamoDB and S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:GetItem",
        ]
        Resource = [
          aws_dynamodb_table.user_info.arn
        ]
      }
    ]
  })
}


# Attach policy to user
resource "aws_iam_user_policy_attachment" "api_user_policy_attach" {
  user       = aws_iam_user.api_user.name
  policy_arn = aws_iam_policy.api_policy.arn
}

# Generate access keys for the IAM user
resource "aws_iam_access_key" "api_user_key" {
  user = aws_iam_user.api_user.name
}

# Store the access keys in AWS Secrets Manager
resource "random_string" "suffix" {
  length  = 4
  special = false
}

resource "aws_secretsmanager_secret" "api_keys" {
  name = "OMA-MIRROR-AUTH-${upper(var.environment)}-${random_string.suffix.result}"

  tags = {
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "api_keys_version" {
  secret_id = aws_secretsmanager_secret.api_keys.id
  secret_string = jsonencode({
    access_key = aws_iam_access_key.api_user_key.id,
    secret_key = aws_iam_access_key.api_user_key.secret
  })
}

