#############################################################
# Lambda Function
#############################################################

# Define an archive_file datasource that creates the lambda archive
data "archive_file" "lambda" {
 type        = "zip"
 #source_file = "hello.py"
 source_dir  = "./package"
 output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "lambda_func" {
 function_name = "yap-sqs-processing"
 role          = aws_iam_role.lambda_exec_role.arn
 handler       = "lambda_function.lambda_handler"
 runtime       = "python3.8"
 filename      = data.archive_file.lambda.output_path

  # Environment Variables
  /* environment {
    variables = {
       	DDB_TABLE = "yap-topmovies"
    }
  } */
}

# aws_cloudwatch_log_group to get the logs of the Lambda execution.
resource "aws_cloudwatch_log_group" "lambda_log_group" {
 name              = "/aws/lambda/yap-sqs-processing"
 retention_in_days = 14
}

# SQS event to trigger Lambda function
resource "aws_lambda_event_source_mapping" "sqs_trigger_lambda" {
  event_source_arn = aws_sqs_queue.sqs_queue.arn
  function_name    = aws_lambda_function.lambda_func.arn
}

#############################################################
# Simple Queue Service (SQS)
#############################################################
resource "aws_sqs_queue" "sqs_queue" {
  name = "yap-work-queue"

  tags = {
    name = "yap-work-queue"
  }
}