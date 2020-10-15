variable "access_key_id" {
	default=""
}
variable "secret_key_id" {
	default=""
}
variable "vpc_cidr" {
	default = "10.20.0.0/16"
}
variable "subnet1_cidr" {
	default = "10.20.1.0/24"
}
variable "subnet2_cidr" {
	default = "10.20.2.0/24"
}
variable "subnet3_cidr" {
	default = "10.20.3.0/24"
}
variable "routeTable_cidr" {
	default = "0.0.0.0/0"
}
variable "profile" {
  description = "The AWS profile on which Terraform has to create resources"
}
variable "aws_region" {
	description = "Region where you want to create VPC"
}
variable "vpcname"{
	description = "Pass the Name attribute/Tag for your VPC"
}

