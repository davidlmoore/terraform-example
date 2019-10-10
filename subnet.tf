// shared/main.tf
/*
 * Create public and private subnets for each availability zone
 */
resource "aws_subnet" "public_subnet" {
 count             = "${length(var.aws_zones)}"
 vpc_id            = "${aws_vpc.vpc.id}"
 availability_zone = "${element(var.aws_zones, count.index)}"
 cidr_block        = "10.0.${(count.index + 1) * 10}.0/24"

 tags {
   Name = "public-${element(var.aws_zones, count.index)}"
 }
}

resource "aws_subnet" "private_subnet" {
 count             = "${length(var.aws_zones)}"
 vpc_id            = "${aws_vpc.vpc.id}"
 availability_zone = "${element(var.aws_zones, count.index)}"
 cidr_block        = "10.0.${(count.index + 1) * 11}.0/24"

 tags {
   Name = "private-${element(var.aws_zones, count.index)}"
 }
}