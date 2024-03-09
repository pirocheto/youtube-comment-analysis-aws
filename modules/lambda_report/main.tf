resource "aws_ecr_repository" "repository" {
  name = "youtube-comment-analysis-repository"
}

resource "null_resource" "build_lambda_image" {
  triggers = {
    always_run = timestamp()
    dir_sha1   = join("", [for f in fileset(var.lambda_source_dir, "**") : filesha1("${var.lambda_source_dir}/${f}")])
  }

  provisioner "local-exec" {
    command = <<-EOT
      cd ${var.lambda_source_dir}
      poetry export --only main \
                    --without-hashes \
                    --format=requirements.txt \
                    > requirements-poetry.txt

      docker build --platform linux/amd64 -t ${aws_ecr_repository.repository.repository_url}:dev .
    EOT
  }
}

resource "null_resource" "push_lambda_image" {
  depends_on = [null_resource.build_lambda_image]

  triggers = {
    always_run = timestamp()
    dir_sha1   = join("", [for f in fileset(var.lambda_source_dir, "**") : filesha1("${var.lambda_source_dir}/${f}")])
  }

  provisioner "local-exec" {
    command = <<-EOT
      aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.repository.repository_url}
      docker push ${aws_ecr_repository.repository.repository_url}:dev
    EOT
  }
}


resource "aws_lambda_function" "lambda_function" {
  tags          = var.tags
  description   = "Lambda function creating PDF report"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.repository.repository_url}:dev"
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  architectures = ["x86_64"]
  timeout       = 520
  depends_on    = [null_resource.push_lambda_image]
  # source_code_hash = join("", [for f in fileset(var.lambda_source_dir, "**") : filesha1("${var.lambda_source_dir}/${f}")])
  # source_code_hash = timestamp()

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
      env         = "local"
    }
  }
}






# resource "null_resource" "install_dependencies" {
#   triggers = {
#     dir_sha1 = join("", [for f in fileset(var.lambda_source_dir, "**") : filesha1("${var.lambda_source_dir}/${f}")])
#   }

#   provisioner "local-exec" {
#     command = <<-EOT
#       cd ${var.lambda_source_dir}
#       rm -r lib dist
#       poetry export --only main \
#                     --without-hashes \
#                     --format=requirements.txt \
#                     > requirements-poetry.txt
#       poetry run pip install -r requirements-poetry.txt \
#                              --target ./lib/python
#     EOT
#   }
# }



# data "archive_file" "dependency_layer" {
#   type        = "zip"
#   source_dir  = "${var.lambda_source_dir}/lib/"
#   output_path = "${var.lambda_source_dir}/dist/layers/dependencies.zip"
#   depends_on  = [null_resource.install_dependencies]
# }

# data "archive_file" "lambda_function" {
#   type        = "zip"
#   source_dir  = "${var.lambda_source_dir}/src/"
#   output_path = "${var.lambda_source_dir}/dist/lambda_function.zip"
# }

# resource "aws_lambda_layer_version" "dependency_layer" {
#   description         = "Layer for dependencies of the Lambda function creating PDF report"
#   layer_name          = var.dependency_layer_name
#   filename            = data.archive_file.dependency_layer.output_path
#   source_code_hash    = data.archive_file.dependency_layer.output_base64sha256
#   compatible_runtimes = [var.runtime]
# }

# resource "aws_lambda_function" "lambda_function" {
#   tags             = var.tags
#   description      = "Lambda function creating PDF report"
#   filename         = data.archive_file.lambda_function.output_path
#   function_name    = var.lambda_function_name
#   role             = aws_iam_role.lambda_role.arn
#   handler          = "lambda_function.lambda_handler"
#   runtime          = var.runtime
#   architectures    = ["arm64"]
#   timeout          = 520
#   source_code_hash = data.archive_file.lambda_function.output_base64sha256
#   layers = [
#     aws_lambda_layer_version.dependency_layer.arn,
#     # "arn:aws:lambda:eu-west-1:336392948345:layer:AWSSDKPandas-Python310-Arm64:11"
#   ]

#   environment {
#     variables = {
#       BUCKET_NAME = var.bucket_name
#     }
#   }
# }



