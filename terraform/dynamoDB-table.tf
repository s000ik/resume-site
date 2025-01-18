# Create DynamoDB table
resource "aws_dynamodb_table" "table" {
  name           = "cloud-resume-table-but-terraformed"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "ID"

  attribute {
    name = "ID"
    type = "S"
  }

  tags = {
    Project = var.project_name
  }
}

# Insert initial item with view count
resource "aws_dynamodb_table_item" "initial_view_count" {
  table_name = aws_dynamodb_table.table.name
  hash_key   = aws_dynamodb_table.table.hash_key

  item = jsonencode({
    "ID"         = { "S": "0" }
    "view_count" = { "N": "0" } # I had about 1700 views during the dev phase, before completely implementing Terraform
  })

  lifecycle {
    ignore_changes = [item] # Ignore changes to the item
  }
}
