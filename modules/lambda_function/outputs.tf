output "lambda_function_arn" {
  value       = aws_lambda_function.lambda_function.arn
  description = "ARN of the Lambda function"
}
