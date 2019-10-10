// service/remote-shared.tf
data "terraform_remote_state" "shared" {
 backend = "s3"

 config {
   bucket = "terraform-sample-bucket1"
   key    = "shared/terraform.tfstate"
   region = "us-east-2"
 }
}