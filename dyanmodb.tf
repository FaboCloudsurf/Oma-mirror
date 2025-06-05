# DynamoDB Table
resource "aws_dynamodb_table" "user_info" {
  name           = "oma-mirror-user-info-${var.environment}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Username"
  range_key      = "SerialNumber"

  attribute {
    name = "Username"
    type = "S"
  }

  attribute {
    name = "Lastname"
    type = "S"
  }
attribute {
    name = "Email"
    type = "S"
  }

  attribute {
    name = "SerialNumber"
    type = "S"
  }

# Add a Global Secondary Index (GSI) for Email
  global_secondary_index {
    name               = "EmailIndex"
    hash_key           = "Email"
    projection_type    = "ALL"
  }

  # Add a Global Secondary Index (GSI) for Lastname
  global_secondary_index {
    name               = "LastnameIndex"
    hash_key           = "Lastname"
    projection_type    = "ALL"
  }
  
  tags = {
    Environment = var.environment
  }
}