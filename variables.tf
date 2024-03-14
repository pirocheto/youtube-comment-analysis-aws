variable "prefix" {
  type        = string
  default     = "youtube-comment-analysis"
  description = "Prefix for Terraform resource names (e.g., policies, roles, Lambda functions, etc.)."
}

variable "lambda_data_source_dir" {
  type        = string
  default     = "01_lambda_data"
  description = "Source directory containing Lambda function code (data)"
}

variable "lambda_transform_source_dir" {
  type        = string
  default     = "02_lambda_transform"
  description = "Source directory containing Lambda function code (transform)"
}

variable "lambda_format_source_dir" {
  type        = string
  default     = "03_lambda_format"
  description = "Source directory containing Lambda function code (format)"
}

variable "lambda_analyze_source_dir" {
  type        = string
  default     = "04_lambda_analyze"
  description = "Source directory containing Lambda function code (analyze)"
}

variable "lambda_report_source_dir" {
  type        = string
  default     = "lambda_report"
  description = "Source directory containing Lambda function code (report)"
}

variable "lambda_runtime" {
  type        = string
  default     = "python3.10"
  description = "Runtime to execute Lambda function"
}

variable "youtube_api_key_secret_name" {
  type        = string
  default     = "YOUTUBE_API_KEY_V2"
  description = "Name of the AWS Secrets Manager secret storing the YouTube API key"
}

variable "tags" {
  type = map(string)
  default = {
    project = "YouTube Comment Analysis"
    env     = "dev"
  }
  description = "Tags to assign for each resource"
}

variable "region" {
  type    = string
  default = "eu-west-1"
}
