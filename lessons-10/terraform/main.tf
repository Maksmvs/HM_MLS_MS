provider "aws" {
  region = var.region
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "validate" {
  function_name = "validate-fn"
  role          = aws_iam_role.lambda_role.arn
  handler       = "validate.lambda_handler"
  runtime       = var.lambda_runtime
  filename      = "${path.module}/lambda/validate.zip"
}

resource "aws_lambda_function" "log_metrics" {
  function_name = "log-metrics-fn"
  role          = aws_iam_role.lambda_role.arn
  handler       = "log_metrics.lambda_handler"
  runtime       = var.lambda_runtime
  filename      = "${path.module}/lambda/log_metrics.zip"
}

resource "aws_iam_role" "stepfn_role" {
  name = "stepfn-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "states.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "stepfn_lambda" {
  role       = aws_iam_role.stepfn_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaRole"
}

resource "aws_sfn_state_machine" "mlops_pipeline" {
  name     = "mlops-train-pipeline"
  role_arn = aws_iam_role.stepfn_role.arn

  definition = jsonencode({
    Comment = "ML pipeline",
    StartAt = "ValidateData",
    States = {
      ValidateData = {
        Type     = "Task",
        Resource = aws_lambda_function.validate.arn,
        Next     = "LogMetrics"
      },
      LogMetrics = {
        Type     = "Task",
        Resource = aws_lambda_function.log_metrics.arn,
        End      = true
      }
    }
  })
}
