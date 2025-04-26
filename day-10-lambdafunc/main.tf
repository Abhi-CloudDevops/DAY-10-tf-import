provider "aws" {
  region = "ap-south-1" 
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

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

resource "aws_lambda_function" "my_lambda" {
  function_name = "myLambdaFunction"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.handler"
  runtime       = "python3.9"

  filename      = "lambda_function.zip"  

  source_code_hash = filebase64sha256("lambda_function.zip")
}

