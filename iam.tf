#Create Lambda basic execution role
resource "aws_iam_role" "lambda_exec_role" {
 name = "yap-lambda-sqs-role"
  assume_role_policy = jsonencode({
   Version = "2012-10-17",
   Statement = [
     {
       Action = "sts:AssumeRole",
       Principal = {
         Service = "lambda.amazonaws.com"
       },
       Effect = "Allow"
     }
   ]
 })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
 role       = aws_iam_role.lambda_exec_role.name
 policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach AWS managed policy ‘AWSLambdaSQSQueueExecutionRole’ to the Lambda execution role
resource "aws_iam_policy_attachment" "aws_sqs_exec_attach" {
  name = "yap_sqs_exec_attach"
  roles = [aws_iam_role.lambda_exec_role.name]
  policy_arn = data.aws_iam_policy.aws_sqs_exec_policy.arn
}