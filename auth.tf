provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# terraform {
#   required_providers {
#     aws = {
#       source = "hashicorp/aws"
#       version = "5.58.0"
#     }
#   }
# }

# provider "aws" {
#   # Configuration options
# }