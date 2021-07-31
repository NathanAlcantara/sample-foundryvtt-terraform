resource "aws_iam_user" "foundry-user" {
  name = "foundry-user"
}

resource "aws_iam_access_key" "foundry-user" {
  user    = aws_iam_user.foundry-user.name
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
                "${var.foundry_bucket_arn}/*",
                "${var.foundry_bucket_arn}"
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