resource "aws_s3_bucket" "superstore_terraform_state" {
  bucket = "superstore-terraform-state-file"
  versioning {
    enabled = true
  }
  tags = {
    Name        = "superstore_terraform_state_file"
    Environment = "Dev"
  }
}

// For state file encrytion in S3 use KMS encrytion

resource "aws_dynamodb_table" "superstore_terraform_locks" {
  name         = "superstore-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "superstore_terraform_locks"
    Environment = "Dev"
  }
}