resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name                        = "terraform-state-lock"
  hash_key                    = "LockID"
  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = true

  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}
