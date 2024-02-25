variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket"
}

variable "lambda_function_arn" {
  type        = string
  description = "ARN of the Lambda function"
}

variable "state_machine_name" {
  type        = string
  description = "Name of the Step Functions state machine"
}

variable "catalog_table_name" {
  type        = string
  description = "Name of the Glue catalog table"
}

variable "catalog_database_name" {
  type        = string
  description = "Name of the Glue catalog database"
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
