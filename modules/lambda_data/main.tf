resource "null_resource" "install_dependencies" {
  triggers = {
    dir_sha1 = join("", [for f in fileset(var.lambda_source_dir, "**") : filesha1("${var.lambda_source_dir}/${f}")])
  }

  provisioner "local-exec" {
    command = <<-EOT
      cd ${var.lambda_source_dir}
      poetry export --without-hashes \
                    --format=requirements.txt \
                    > requirements-poetry.txt
      poetry run pip install -r requirements-poetry.txt \
                             --target ./lib/python
    EOT
  }
}



data "archive_file" "dependency_layer" {
  type        = "zip"
  source_dir  = "${var.lambda_source_dir}/lib/"
  output_path = "${var.lambda_source_dir}/dist/layers/dependencies.zip"
  depends_on  = [null_resource.install_dependencies]
}

data "archive_file" "lambda_function" {
  type        = "zip"
  source_dir  = "${var.lambda_source_dir}/src/"
  output_path = "${var.lambda_source_dir}/dist/lambda_function.zip"
}

resource "aws_lambda_layer_version" "dependency_layer" {
  description         = "Layer for dependencies of the Lambda function getting YouTube comments"
  layer_name          = var.dependency_layer_name
  filename            = data.archive_file.dependency_layer.output_path
  source_code_hash    = data.archive_file.dependency_layer.output_base64sha256
  compatible_runtimes = [var.runtime]
}

resource "aws_lambda_function" "lambda_function" {
  tags             = var.tags
  description      = "Lambda function getting YouTube comments"
  filename         = data.archive_file.lambda_function.output_path
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = var.runtime
  architectures    = ["arm64"]
  timeout          = 520
  source_code_hash = data.archive_file.lambda_function.output_base64sha256
  layers           = [aws_lambda_layer_version.dependency_layer.arn]

  environment {
    variables = {
      YOUTUBE_API_KEY_SECRET_NAME = var.youtube_api_key_secret_name
      BUCKET_NAME                 = var.bucket_name
    }
  }
}



