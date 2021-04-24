resource "aws_s3_bucket" "foundry" {
  bucket = "foundry-vtt-rpg-storage"
}

resource "aws_s3_bucket_public_access_block" "foundry" {
  bucket = aws_s3_bucket.foundry.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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

resource "aws_iam_user" "foundry-user" {
  name = "foundry-user"
}

resource "aws_iam_user_policy" "foundry-policy" {
  name = "foundry-policy"
  user = aws_iam_user.foundry-user.name

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:DeleteObject",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "${aws_s3_bucket.foundry.arn}/*",
                "${aws_s3_bucket.foundry.arn}"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "*"
        }
    ]
}
POLICY
}
