resource "aws_s3_bucket" "oma_automation_bucket" {
  bucket = "oma-automation-bucket-${var.environment}"

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.oma_automation_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "oma-acl" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.oma_automation_bucket.id
  acl    = "private"


}

 resource "aws_s3_bucket_public_access_block" "oma-pab" {
  bucket = aws_s3_bucket.oma_automation_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "oma_bucket_policy" {
  bucket = aws_s3_bucket.oma_automation_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "RestrictedAccess"
        Effect    = "Allow"
        Principal = {
          AWS = aws_iam_user.api_user.arn
        }
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.oma_automation_bucket.arn}/*"
      }
    ]
  })
}
