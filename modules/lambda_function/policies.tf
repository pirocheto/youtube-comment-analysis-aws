resource "aws_iam_role" "lambda_role" {
  name        = var.iam_role_name
  description = "IAM Role for Lambda function getting YouTube comments"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = var.iam_policy_name
  description = "IAM Policy for Lambda function getting YouTube comments"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*"
      },
      {
        "Effect" : "Allow",
        "Action" : ["s3:PutObject"],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : ["secretsmanager:GetSecretValue"],
        "Resource" : "arn:aws:secretsmanager:*:*:secret:*"
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_policy_attach" {
  name       = var.iam_policy_attach_name
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.lambda_policy.arn
}
