resource "aws_iam_role" "state_machine_role" {
  name        = var.iam_role_name
  description = "IAM Role for State Machine processing Youtube comments"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "state_machine_policy" {
  name        = var.iam_policy_name
  description = "IAM Policy for State Machine processing Youtube comments"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "lambda:InvokeFunction"
        Resource = [
          var.lambda_data_function_arn,
          var.lambda_transform_function_arn,
          var.lambda_format_function_arn,
          var.lambda_analyze_function_arn,
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
        ],
        Resource = "${var.bucket_arn}*"
      },
      {
        Effect   = "Allow"
        Action   = "states:StartExecution"
        Resource = aws_sfn_state_machine.state_machine.arn
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "state_machine_policy_attach" {
  name       = var.iam_policy_attach_name
  roles      = [aws_iam_role.state_machine_role.name]
  policy_arn = aws_iam_policy.state_machine_policy.arn
}
