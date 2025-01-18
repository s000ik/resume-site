# Creating IAM user for Terraform
resource "aws_iam_user" "terraform" {
  name = "terraform-cloud-resume"
  
  tags = {
    Project = var.project_name
  }
}

# Attach AdministratorAccess policy to Terraform user (For now)
resource "aws_iam_user_policy_attachment" "admin_policy" {
  user       = aws_iam_user.terraform.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# S3 bucket for terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "cloud-resume-terraform-state-bucket"

  tags = {
    Project = var.project_name
  }

  depends_on = [aws_iam_user.terraform]
}

# Enable versioning for state files
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create DynamoDB table for state locking (Terraform handles the locking mechanism, just need to declare LockID)
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "cloud-resume-terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Project = var.project_name
  }

  depends_on = [aws_s3_bucket.terraform_state]
}