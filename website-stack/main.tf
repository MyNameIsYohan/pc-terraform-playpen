terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 3.0"
   }
 }
}

provider "aws" {
  region = "eu-west-1"
}

terraform {
 backend "s3" {
   bucket         = "yohanes-parkmobile-tf"
   key            = "state/tf.tfstate"
   region         = "eu-west-1"
   encrypt        = true
   kms_key_id     = "alias/tf-bucket-key"
   dynamodb_table = "tf-state"
 }
}