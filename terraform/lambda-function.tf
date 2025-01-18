# Create a Lambda function using Terraform
resource "aws_lambda_function" "cloud-resume-func-but-terraformed" {
  function_name = var.lambda_function_name
  filename         = data.archive_file.zip_the_python_code.output_path
  source_code_hash = data.archive_file.zip_the_python_code.output_base64sha256
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "func.lambda_handler"
  runtime          = var.lambda_runtime

  tags = {
    Project = var.project_name
  }

  depends_on = [data.archive_file.zip_the_python_code]
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  tags = {
    Project = var.project_name
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Sid = ""
      }
    ]
  })
}

resource "aws_iam_policy" "iam_policy_for_resume_project" {
  name        = "aws_iam_policy_for_terraform_resume_project_policy"
  path        = "/"
  description = "AWS IAM Policy for managing the resume project role"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:UpdateItem",
          "dynamodb:GetItem",
          "dynamodb:DescribeTable"
        ]
        Resource = aws_dynamodb_table.table.arn 
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.iam_policy_for_resume_project.arn

  depends_on = [aws_iam_policy.iam_policy_for_resume_project]
}


# zip the python code
data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_file = "../lambda/func.py"
  output_path = "../lambda/func.zip"
}

# Create the function URL for the Lambda function
resource "aws_lambda_function_url" "url1" {
  function_name      = aws_lambda_function.cloud-resume-func-but-terraformed.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = false
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["*"]
    expose_headers    = []
    max_age           = 0
  }

  depends_on = [aws_lambda_function.cloud-resume-func-but-terraformed]
}

