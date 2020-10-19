provider "aws" {
	region = "${var.aws_region}"
  profile = "${var.profile}"
  access_key = "${var.access_key_id}"
  secret_key = "${var.secret_key_id}"
}

# VPC
resource "aws_vpc" "csye6225-vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_classiclink_dns_support = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "${var.vpcname}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "csye6225-gateway" {
  vpc_id = "${aws_vpc.csye6225-vpc.id}"
  tags = {
    Name = "${var.vpcname}-gateway"
  }
}

# Subnets 
resource "aws_subnet" "subnet1" {
  
  vpc_id = "${aws_vpc.csye6225-vpc.id}"
  cidr_block = "${var.subnet1_cidr}"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpcname}-subnet1"
  }
}
resource "aws_subnet" "subnet2" {
  
  vpc_id = "${aws_vpc.csye6225-vpc.id}"
  cidr_block = "${var.subnet2_cidr}"
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags ={
    Name = "${var.vpcname}-subnet2"
  }
}
resource "aws_subnet" "subnet3" {
  
  vpc_id = "${aws_vpc.csye6225-vpc.id}"
  cidr_block = "${var.subnet3_cidr}"
  availability_zone = "${var.aws_region}c"
  map_public_ip_on_launch = true
  tags ={
    Name = "${var.vpcname}-subnet3"
  }
}
# Route table
resource "aws_route_table" "route-table" {
  vpc_id = "${aws_vpc.csye6225-vpc.id}"
  route {
    cidr_block = "${var.routeTable_cidr}"
    gateway_id = "${aws_internet_gateway.csye6225-gateway.id}"
  }
  
  tags ={
    Name = "${var.vpcname}-Route-table"
  }
}

# Route table association with subnets
resource "aws_route_table_association" "route-subnet1" {
  subnet_id      = "${aws_subnet.subnet1.id}"
  route_table_id = "${aws_route_table.route-table.id}"
}

resource "aws_route_table_association" "route-subnet2" {
  subnet_id      = "${aws_subnet.subnet2.id}"
  route_table_id = "${aws_route_table.route-table.id}"
}

resource "aws_route_table_association" "route-subnet3" {
  subnet_id      = "${aws_subnet.subnet3.id}"
  route_table_id = "${aws_route_table.route-table.id}"
}

resource "aws_security_group" "app-security-group"{
name = "application security group"
description = "Open ports 22, 80, 443 and 8080"
vpc_id = "${aws_vpc.csye6225-vpc.id}"

ingress{
description = "Allow inbound HTTP traffic"
from_port = "80"
to_port = "80"
protocol = "tcp"
cidr_blocks = ["${var.routeTable_cidr}"]
}
ingress{
description = "Allow inbound SSH traffic"
from_port = "22"
to_port = "22"
protocol = "tcp"
cidr_blocks = ["${var.routeTable_cidr}"]
}
ingress{
description = "Allow inbound HTTPS traffic"
from_port = "443"
to_port = "443"
protocol = "tcp"
cidr_blocks = ["${var.routeTable_cidr}"]
}
ingress{
description = "Allow traffic to application port"
from_port = "8080"
to_port = "8080"
protocol = "tcp"
cidr_blocks = ["${var.routeTable_cidr}"]
}
tags ={
Name = "application security group"
}
}
resource "aws_security_group" "db-security-group"{
name = "database security group"
description = "Open port 3306 for Database traffic"
vpc_id = "${aws_vpc.csye6225-vpc.id}"

ingress{
description = "Allow inbound Database traffic"
from_port = "3306"
to_port = "3306"
protocol = "tcp"
cidr_blocks = ["${var.subnet1_cidr}"]
}
tags ={
Name = "database security group"
}
}


resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucketname}"
  acl = "private"
  force_destroy = true
  lifecycle_rule {
    enabled = true
    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "${var.db-subnet-group}"
  subnet_ids = [aws_subnet.subnet1.id , aws_subnet.subnet2.id]

  tags = {
    Name = "DB Subnet Group "
  }
}

resource "aws_db_instance" "database-server" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "${var.db-instance-class}"
  identifier           = "${var.db-identifier}"
  name                 = "${var.dbname}"
  username             = "${var.db-username}"
  password             = "${var.db-password}"
  parameter_group_name = "default.mysql5.7"
  publicly_accessible  = false
  db_subnet_group_name = "${aws_db_subnet_group.db-subnet-group.name}"
  vpc_security_group_ids = ["${aws_security_group.db-security-group.id}"]
  multi_az = false
  skip_final_snapshot = true
  tags = {
    Name = "MySQL Database Server"
  }
}
resource "aws_instance" "appserver" {
  ami                                  = "${var.ami-id}"
  instance_type                        = "${var.ec2-instance-type}"
  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids               = ["${aws_security_group.app-security-group.id}"]
  subnet_id                            = "${aws_subnet.subnet1.id}"
  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }
  tags = {
    Name = "Application Server"
  }
}

resource "aws_dynamodb_table_item" "dynamo_db_item" {
  table_name = aws_dynamodb_table.dynamodb_table.name
  hash_key   = aws_dynamodb_table.dynamodb_table.hash_key

  item = <<ITEM
{
  "id": {"S": "something"}
}
ITEM
}
resource "aws_dynamodb_table" "dynamodb_table" {
  name           = "${var.dynamodb-name}"
  hash_key       = "id"
  read_capacity    = 10
  write_capacity   = 10
  attribute {
    name = "id"
    type = "S"
  }
}
# IAM POLICY
resource "aws_iam_policy" "WebAppS3" {
  name        = "${var.s3policyName}"
  description = "Policy for EC2 instance to use S3"
policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": ["${aws_s3_bucket.bucket.arn}"]
    }
  ]
}
EOF
}
# IAM ROLE
resource "aws_iam_role" "ec2role" {
  name = "${var.s3roleName}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
    "Action": "sts:AssumeRole",
    "Principal": {
    "Service": "ec2.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
  }
  ]
}
EOF
  tags = {
    Name = "EC2 - S3 access policy"
  }
}

resource "aws_iam_role_policy_attachment" "role_policy_attacher" {
  role       = aws_iam_role.ec2role.name
  policy_arn = aws_iam_policy.WebAppS3.arn
}
# USER DATA