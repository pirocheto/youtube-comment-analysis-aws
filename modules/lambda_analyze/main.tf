data "archive_file" "lambda_function" {
  type        = "zip"
  source_dir  = "${var.lambda_source_dir}/src/"
  output_path = "${var.lambda_source_dir}/dist/lambda_function.zip"
}

resource "aws_lambda_function" "lambda_function" {
  tags          = var.tags
  description   = "Lambda function creating statistics from YouTube Comments"
  filename      = data.archive_file.lambda_function.output_path
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  runtime       = var.runtime
  handler       = "lambda_function.lambda_handler"
  architectures = ["arm64"]
  timeout       = 300
  memory_size   = 256
  layers        = ["arn:aws:lambda:eu-west-1:336392948345:layer:AWSSDKPandas-Python310-Arm64:13"]
  # source_code_hash = join("", [for f in fileset(var.lambda_source_dir, "**") : filesha1("${var.lambda_source_dir}/${f}")])
  # source_code_hash = timestamp()

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
    }
  }
}



# resource "aws_ecr_repository" "repository" {
#   # name = "youtube-comment-analysis-repository"
#   name = var.ecr_repository_name
# }

# resource "null_resource" "build_lambda_image" {
#   triggers = {
#     always_run = timestamp()
#     dir_sha1   = join("", [for f in fileset(var.lambda_source_dir, "**") : filesha1("${var.lambda_source_dir}/${f}")])
#   }

#   provisioner "local-exec" {
#     command = <<-EOT
#       cd ${var.lambda_source_dir}
#       poetry export --only main \
#                     --without-hashes \
#                     --format=requirements.txt \
#                     > requirements-poetry.txt

#       docker build --platform linux/amd64 -t ${aws_ecr_repository.repository.repository_url}:dev .
#     EOT
#   }
# }

# resource "null_resource" "push_lambda_image" {
#   depends_on = [null_resource.build_lambda_image]

#   triggers = {
#     always_run = timestamp()
#     dir_sha1   = join("", [for f in fileset(var.lambda_source_dir, "**") : filesha1("${var.lambda_source_dir}/${f}")])
#   }

#   provisioner "local-exec" {
#     command = <<-EOT
#       aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.repository.repository_url}
#       docker push ${aws_ecr_repository.repository.repository_url}:dev
#     EOT
#   }
# }


# resource "aws_lambda_function" "lambda_function" {
#   tags          = var.tags
#   description   = "Lambda function creating statistics from YouTube Comments"
#   package_type  = "Image"
#   image_uri     = "${aws_ecr_repository.repository.repository_url}:dev"
#   function_name = var.lambda_function_name
#   role          = aws_iam_role.lambda_role.arn
#   architectures = ["x86_64"]
#   timeout       = 300
#   memory_size   = 2048
#   depends_on    = [null_resource.push_lambda_image]
#   # source_code_hash = join("", [for f in fileset(var.lambda_source_dir, "**") : filesha1("${var.lambda_source_dir}/${f}")])
#   # source_code_hash = timestamp()

#   environment {
#     variables = {
#       BUCKET_NAME = var.bucket_name
#     }
#   }
# }




