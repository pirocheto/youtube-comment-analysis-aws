variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket"
}

variable "lambda_data_function_arn" {
  type        = string
  description = "ARN of the Lambda function (data)"
}

variable "lambda_data_function_name" {
  type        = string
  description = "ARN of the Lambda function (data)"
}

variable "lambda_transform_function_arn" {
  type        = string
  description = "ARN of the Lambda function (data)"
}

variable "lambda_transform_function_name" {
  type        = string
  description = "ARN of the Lambda function (transform)"
}

variable "lambda_analyze_function_arn" {
  type        = string
  description = "ARN of the Lambda function (data)"
}

variable "lambda_analyze_function_name" {
  type        = string
  description = "ARN of the Lambda function (analyze)"
}

variable "lambda_format_function_arn" {
  type        = string
  description = "ARN of the Lambda function (format)"
}

variable "lambda_format_function_name" {
  type        = string
  description = "ARN of the Lambda function (format)"
}

variable "state_machine_name" {
  type        = string
  description = "Name of the Step Functions state machine"
}

variable "iam_role_name" {
  type        = string
  description = "Name of the IAM role"
}

variable "iam_policy_name" {
  type        = string
  description = "Name of the IAM policy"
}

variable "iam_policy_attach_name" {
  type        = string
  description = "Name of the IAM policy attachment"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to AWS resources"
}
