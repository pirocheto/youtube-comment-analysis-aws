output "bucket_arn" {
  value       = aws_s3_bucket.s3_bucket.arn
  description = "ARN of the Bucket"
}
