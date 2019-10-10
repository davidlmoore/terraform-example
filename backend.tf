// shared/backend.tf
terraform {
 backend "s3" {
   bucket         = "terraform-sample-bucket1"
   key            = "shared/terraform.tfstate"
   region         = "us-east-2"
   encrypt        = true
   dynamodb_table = "terraform-lock-sample1"
 }
}