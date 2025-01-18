# General AWS Configuration
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "cloud-resume"
}

# Lambda Configuration
variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "cloud-resume-func-but-terraformed"
}

variable "lambda_runtime" {
  description = "Runtime for Lambda function"
  type        = string
  default     = "python3.13"
}

# API Gateway Configuration
variable "api_gateway_name" {
  description = "Name of API Gateway REST API"
  type        = string
  default     = "cloud-resume-rest-api-but-terraformed"
}

variable "stage_name" {
  description = "API Gateway stage name"
  type        = string
  default     = "prod"
}


# IAM Configuration
variable "lambda_role_name" {
  description = "Name of IAM role for Lambda function"
  type        = string
  default     = "iam_for_lambda"
}

variable "lambda_policy_name" {
  description = "Name of IAM policy for Lambda function"
  type        = string
  default     = "aws_iam_policy_for_terraform_resume_project_policy"
}

#s3 bucket configuration
variable "website_bucket_name" {
  description = "Name of the S3 bucket for website"
  type        = string
  default     = "satwiks-cloud-resume-but-terraformed"
}

# Sensitve variables
variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ACM certificate arn"
  type        = string
}