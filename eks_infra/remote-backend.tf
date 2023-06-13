# resource "aws_s3_bucket" "remote_tf_state" {
#   bucket = "zedan-terraform-backend"

#   # Prevent accidental deletion of s3 bucket
#   lifecycle {
#     prevent_destroy = true
#   }
# }

# resource "aws_s3_bucket_versioning" "versioning" {
#   bucket   = aws_s3_bucket.remote_tf_state.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_dynamodb_table" "dynamodb_for_tf_locks" {
#   name            = "dynamodb_table_for_tf_locks"
#   billing_mode    = "PAY_PER_REQUEST"
#   hash_key        = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }


terraform {
  backend "s3" {
    bucket         = "zedan-terraform-backend"
    dynamodb_table = "dynamodb_table_for_tf_locks"
    key            = "zedan/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}