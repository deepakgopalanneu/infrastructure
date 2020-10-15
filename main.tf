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
    Name = "CSYE6225-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "csye6225-gateway" {
  vpc_id = "${aws_vpc.csye6225-vpc.id}"
  tags = {
    Name = "CSYE6225Gateway"
  }
}

# Subnets 
resource "aws_subnet" "subnet1" {
  
  vpc_id = "${aws_vpc.csye6225-vpc.id}"
  cidr_block = "${var.subnet1_cidr}"
  availability_zone = "${var.az1}"
  map_public_ip_on_launch = true
  tags = {
    Name = "Subnet-1"
  }
}
resource "aws_subnet" "subnet2" {
  
  vpc_id = "${aws_vpc.csye6225-vpc.id}"
  cidr_block = "${var.subnet2_cidr}"
  availability_zone = "${var.az2}"
  map_public_ip_on_launch = true
  tags ={
    Name = "Subnet-2"
  }
}
resource "aws_subnet" "subnet3" {
  
  vpc_id = "${aws_vpc.csye6225-vpc.id}"
  cidr_block = "${var.subnet3_cidr}"
  availability_zone = "${var.az3}"
  map_public_ip_on_launch = true
  tags ={
    Name = "Subnet-3"
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
    Name = "CSYE6225-Route-table"
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

# resource "aws_security_group" "open-ports"{
#   name = "Allow-Web-Traffic"
#   description = "Open port 8080 for API, 3306 for Database"
#   vpc_id = "${aws_vpc.csye6225-vpc.id}"

#   ingress{
#     description = "Allow inbound API traffic"
#     from_port = "8080"
#     to_port = "8080"
#     protocol = "tcp"
#     cidr_blocks = [aws_vpc.csye6225-vpc.cidr_block]
#   }
#   ingress{
#     description = "Allow inbound DB traffic"
#     from_port = "3306"
#     to_port = "3306"
#     protocol = "tcp"
#     cidr_blocks = [aws_vpc.csye6225-vpc.cidr_block]
#   }
#   egress {
#     description = "Allow outbound API traffic"
#     from_port = "8080"
#     to_port = "8080"
#     protocol = "tcp"
#     cidr_blocks = [aws_vpc.csye6225-vpc.cidr_block]
#   }
#   egress {
#     description = "Allow outbound DB traffic"
#     from_port = "3306"
#     to_port = "3306"
#     protocol = "tcp"
#     cidr_blocks = [aws_vpc.csye6225-vpc.cidr_block]
#   }
# }