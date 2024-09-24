resource "aws_s3_bucket" "foundry" {
  bucket = "foundryvtt-rpg-storage"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "foundry" {
  bucket = aws_s3_bucket.foundry.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "foundry" {
  bucket = aws_s3_bucket.foundry.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = [
      "GET",
      "POST",
      "HEAD",
    ]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_public_access_block" "foundry" {
  bucket = aws_s3_bucket.foundry.id
}

resource "aws_s3_bucket_policy" "foundry" {
  bucket = aws_s3_bucket.foundry.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Action": "s3:GetObject",
            "Effect": "Allow",
            "Resource": "${aws_s3_bucket.foundry.arn}/*",
            "Principal": "*"
        }
    ]
}
POLICY
}

resource "aws_s3_bucket_ownership_controls" "foundry" {
  bucket = aws_s3_bucket.foundry.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "foundry" {
  depends_on = [
    aws_s3_bucket_ownership_controls.foundry
  ]

  bucket = aws_s3_bucket.foundry.id
  acl    = "public-read"
}
