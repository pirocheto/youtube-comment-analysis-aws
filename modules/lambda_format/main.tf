
data "archive_file" "lambda_function" {
  type        = "zip"
  source_dir  = "${var.lambda_source_dir}/src/"
  output_path = "${var.lambda_source_dir}/dist/lambda_function.zip"
}


resource "aws_lambda_function" "lambda_function" {
  tags             = var.tags
  description      = "Lambda function formatting YouTube comments into CSV file"
  filename         = data.archive_file.lambda_function.output_path
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = var.runtime
  architectures    = ["arm64"]
  timeout          = 520
  source_code_hash = data.archive_file.lambda_function.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
    }
  }
}



