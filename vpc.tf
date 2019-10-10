// shared/main.tf
/*
 * Create VPC 
 */
resource "aws_vpc" "vpc" {
 cidr_block = "10.0.0.0/16"

 tags = {
   Name = "vpc-terraform"
 }
}

/*
 * Get default security group for reference later
 */
data "aws_security_group" "vpc_default_sg" {
 name   = "default"
 vpc_id = "${aws_vpc.vpc.id}"
}