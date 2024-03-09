variable "lambda_source_dir" {
  type        = string
  description = "Directory path where Lambda function source code is located"
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket where Lambda function resources are stored"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "bucket_arn" {
  type        = string
  description = ""
}

variable "runtime" {
  type        = string
  description = "Runtime environment for the Lambda function"
}

variable "lambda_function_name" {
  type        = string
  description = "Name of the Lambda function"
}

variable "dependency_layer_name" {
  type        = string
  description = "Name of the Lambda layer containing dependencies"
}

variable "iam_role_name" {
  type        = string
  description = "Name of the IAM role associated with the Lambda function"
}

variable "iam_policy_name" {
  type        = string
  description = "Name of the IAM policy attached to the IAM role"
}

variable "iam_policy_attach_name" {
  type        = string
  description = "Name of the IAM policy attachment"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to AWS resources"
}
