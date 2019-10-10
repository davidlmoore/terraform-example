// shared/main.tf
/*
 * Determine most recent ECS optimized AMI
 */
data "aws_ami" "ecs_ami" {
 most_recent = true
 owners      = ["amazon"]

 filter {
   name   = "name"
   values = ["amzn-ami-*-amazon-ecs-optimized"]
 }
}

/*
 * Create ECS cluster
 */
resource "aws_ecs_cluster" "ecs_cluster" {
 name = "ecs-cluster"
}

/*
 * Create ECS IAM Instance Role and Policy
 * Use random id in naming of roles to prevent collisions
 * should other ECS clusters be created in same AWS account
 * using this same code. 
 */
resource "random_id" "code" {
 byte_length = 4
}

resource "aws_iam_role" "ecsInstanceRole" {
 name               = "ecsInstanceRole-${random_id.code.hex}"
 assume_role_policy = <<EOF
{
 "Version": "2008-10-17",
 "Statement": [
   {
     "Sid": "",
     "Effect": "Allow",
     "Principal": {
       "Service": "ec2.amazonaws.com"
     },
     "Action": "sts:AssumeRole"
   }
 ]
}
EOF

}

resource "aws_iam_role_policy" "ecsInstanceRolePolicy" {
 name   = "ecsInstanceRolePolicy-${random_id.code.hex}"
 role   = "${aws_iam_role.ecsInstanceRole.id}"
 policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Action": [
       "ecs:CreateCluster",
       "ecs:DeregisterContainerInstance",
       "ecs:DiscoverPollEndpoint",
       "ecs:Poll",
       "ecs:RegisterContainerInstance",
       "ecs:StartTelemetrySession",
       "ecs:Submit*",
       "ecr:GetAuthorizationToken",
       "ecr:BatchCheckLayerAvailability",
       "ecr:GetDownloadUrlForLayer",
       "ecr:BatchGetImage",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "*"
   }
 ]
}
EOF

}

/*
 * Create ECS IAM Service Role and Policy
 */
resource "aws_iam_role" "ecsServiceRole" {
 name               = "ecsServiceRole-${random_id.code.hex}"
 assume_role_policy = <<EOF
{
 "Version": "2008-10-17",
 "Statement": [
   {
     "Sid": "",
     "Effect": "Allow",
     "Principal": {
       "Service": "ecs.amazonaws.com"
     },
     "Action": "sts:AssumeRole"
   }
 ]
}
EOF

}

resource "aws_iam_role_policy" "ecsServiceRolePolicy" {
 name   = "ecsServiceRolePolicy-${random_id.code.hex}"
 role   = "${aws_iam_role.ecsServiceRole.id}"
 policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Action": [
       "ec2:AuthorizeSecurityGroupIngress",
       "ec2:Describe*",
       "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
       "elasticloadbalancing:DeregisterTargets",
       "elasticloadbalancing:Describe*",
       "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
       "elasticloadbalancing:RegisterTargets"
     ],
     "Resource": "*"
   }
 ]
}
EOF

}

resource "aws_iam_instance_profile" "ecsInstanceProfile" {
 name = "ecsInstanceProfile-${random_id.code.hex}"
 role = "${aws_iam_role.ecsInstanceRole.name}"
}

