resource "aws_s3_bucket" "foundry" {
  bucket = "foundry-vtt-rpg-storage"
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
