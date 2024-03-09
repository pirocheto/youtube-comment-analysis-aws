resource "aws_sfn_state_machine" "state_machine" {
  name     = var.state_machine_name
  role_arn = aws_iam_role.state_machine_role.arn
  tags     = var.tags

  definition = jsonencode({
    StartAt = "GetComments"
    States = {
      GetComments = {
        Type       = "Task"
        Resource   = "arn:aws:states:::lambda:invoke"
        OutputPath = "$.Payload",
        Parameters = {
          FunctionName = var.lambda_function_arn
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
        Next = "AnalyzeComments"
      },
      AnalyzeComments = {
        Type = "Map"
        ItemProcessor = {
          ProcessorConfig = {
            Mode          = "DISTRIBUTED"
            ExecutionType = "STANDARD"
          },
          StartAt = "OpenFile"
          States = {
            OpenFile = {
              Type = "Task"
              Parameters = {
                Bucket  = var.bucket_name
                "Key.$" = "$.Key"
              },
              Resource = "arn:aws:states:::aws-sdk:s3:getObject"
              ResultSelector = {
                "Body.$" = "States.StringToJson($.Body)"
              },
              Next = "DetectSentiment"
            },
            DetectSentiment = {
              Type = "Task"
              Parameters = {
                LanguageCode = "fr"
                "Text.$"     = "$.Body.textOriginal"
              }
              Resource   = "arn:aws:states:::aws-sdk:comprehend:detectSentiment"
              ResultPath = "$.Sentiment"
              ResultSelector = {
                "Sentiment.$"              = "$.Sentiment"
                "SentimentScoreMixed.$"    = "$.SentimentScore.Mixed"
                "SentimentScoreNegative.$" = "$.SentimentScore.Negative"
                "SentimentScorePositive.$" = "$.SentimentScore.Positive"
                "SentimentScoreNeutral.$"  = "$.SentimentScore.Neutral"
              },
              Retry = [
                {
                  ErrorEquals = [
                    "States.ALL"
                  ],
                  BackoffRate     = 2,
                  IntervalSeconds = 2,
                  MaxAttempts     = 3
                }
              ]
              Next = "MergeSentiment"
            }
            MergeSentiment = {
              Type       = "Pass"
              OutputPath = "$.Result"
              Parameters = {
                "Result.$" = "States.JsonMerge($.Body, $.Sentiment, false)"
              }
              Next = "PutObject"
            }
            PutObject = {
              Type = "Task"
              End  = true
              Parameters = {
                "Body.$"    = "$"
                Bucket      = var.bucket_name
                ContentType = "application/json"
                "Key.$"     = "States.Format('processed/videoid={}/{}.json', $.videoId, $.id)"
              }
              Resource = "arn:aws:states:::aws-sdk:s3:putObject"
            }
          }
        }
        Label          = "Map"
        MaxConcurrency = 100
        ItemReader = {
          Resource = "arn:aws:states:::s3:listObjectsV2"
          Parameters = {
            "Bucket.$" = "$.bucket.name",
            "Prefix.$" = "$.bucket.prefix"
          }
        }
        ResultPath = "$.Output"
        End        = true
      }
    }
  })
}

