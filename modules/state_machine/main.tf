resource "aws_sfn_state_machine" "state_machine" {
  name     = var.state_machine_name
  role_arn = aws_iam_role.state_machine_role.arn
  tags     = var.tags

  definition = jsonencode({
    StartAt = "Lambda Data"
    "States" : {
      "Lambda Data" = {
        Type       = "Task"
        Resource   = "arn:aws:states:::lambda:invoke"
        OutputPath = "$.Payload",
        Parameters = {
          FunctionName = var.lambda_data_function_name
          Payload = {
            video_id = "Ps5kScYvQQk"
          }
        }
        Retry = [
          {
            ErrorEquals = [
              "Lambda.ServiceException",
              "Lambda.AWSLambdaException",
              "Lambda.SdkClientException",
              "Lambda.TooManyRequestsException"
            ],
            IntervalSeconds = 1
            MaxAttempts     = 3
            BackoffRate     = 2
          }
        ]
        Next = "Lambda Transform"
      }
      "Lambda Transform" = {
        Type       = "Task"
        Resource   = "arn:aws:states:::lambda:invoke"
        OutputPath = "$.Payload"
        Parameters = {
          "Payload.$"  = "$"
          FunctionName = var.lambda_transform_function_name
        }
        Retry = [
          {
            ErrorEquals = [
              "Lambda.ServiceException",
              "Lambda.AWSLambdaException",
              "Lambda.SdkClientException",
              "Lambda.TooManyRequestsException"
            ],
            IntervalSeconds = 1
            MaxAttempts     = 3
            BackoffRate     = 2
          }
        ]
        Next      = "Lambda Format"
        InputPath = "$.output"
      }
      "Lambda Format" = {
        Type       = "Task"
        Resource   = "arn:aws:states:::lambda:invoke"
        OutputPath = "$.Payload"
        Parameters = {
          "Payload.$"  = "$"
          FunctionName = var.lambda_format_function_name
        }
        Retry = [
          {
            ErrorEquals = [
              "Lambda.ServiceException",
              "Lambda.AWSLambdaException",
              "Lambda.SdkClientException",
              "Lambda.TooManyRequestsException"
            ],
            IntervalSeconds = 1
            MaxAttempts     = 3
            BackoffRate     = 2
          }
        ],
        Next      = "Lambda Analyze"
        InputPath = "$.output"
      }
      "Lambda Analyze" = {
        Type       = "Task"
        Resource   = "arn:aws:states:::lambda:invoke"
        OutputPath = "$.Payload"
        Parameters = {
          "Payload.$"  = "$"
          FunctionName = var.lambda_analyze_function_name
        }
        Retry = [
          {
            ErrorEquals = [
              "Lambda.ServiceException",
              "Lambda.AWSLambdaException",
              "Lambda.SdkClientException",
              "Lambda.TooManyRequestsException"
            ]
            IntervalSeconds = 1,
            MaxAttempts     = 3,
            BackoffRate     = 2
          }
        ]
        End       = true,
        InputPath = "$.output"
      }
    }
  })
}

