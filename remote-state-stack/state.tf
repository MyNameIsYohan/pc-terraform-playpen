resource "aws_kms_key" "tf-bucket-key" {
 description             = "This key is used to encrypt bucket objects"
 deletion_window_in_days = 10
 enable_key_rotation     = true
}

resource "aws_kms_alias" "key-alias" {
 name          = "alias/tf-bucket-key"
 target_key_id = aws_kms_key.tf-bucket-key.key_id
}


resource "aws_s3_bucket" "tf-state" {
 bucket = "yohanes-parkmobile-tf"
 acl    = "private"

 tags = {
   Name = "Parkmobile-Training"
   Environment = "Dev"
 }

  server_side_encryption_configuration {
   rule {
     apply_server_side_encryption_by_default {
       kms_master_key_id = aws_kms_key.tf-bucket-key.arn
       sse_algorithm     = "aws:kms"
     }
   }
 }
}

resource "aws_s3_bucket_public_access_block" "block" {
 bucket = aws_s3_bucket.tf-state.id

 block_public_acls       = true
 block_public_policy     = true
 ignore_public_acls      = true
 restrict_public_buckets = true
}

resource "aws_dynamodb_table" "tf-state" {
 name           = "tf-state"
 read_capacity  = 20
 write_capacity = 20
 hash_key       = "LockID"

 attribute {
   name = "LockID"
   type = "S"
 }
}
