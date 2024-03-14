output "lambda_function_arn" {
  value       = aws_lambda_function.lambda_function.arn
  description = "ARN of the Lambda function"
}

output "lambda_function_name" {
  value       = aws_lambda_function.lambda_function.function_name
  description = "Name of the Lambda function"
}
