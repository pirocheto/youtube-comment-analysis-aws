variable "prefix" {
  type        = string
  default     = "youtube-comment-analysis"
  description = "Prefix for Terraform resource names (e.g., policies, roles, Lambda functions, etc.)."
}

variable "lambda_source_dir" {
  type        = string
  default     = "lambda_function"
  description = "Source directory containing Lambda function code"
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