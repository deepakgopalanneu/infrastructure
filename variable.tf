variable "profile" {
  description = "The AWS profile on which Terraform has to create resources"
  default = "dev"
}
variable "access_key_id" {
	default=""
}
variable "secret_key_id" {
	default=""
}
variable "aws_region" {
	default = "us-east-1"
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
variable "az1" {
	default = "us-east-1a"
}
variable "az2" {
	default = "us-east-1b"
}
variable "az3" {
	default = "us-east-1c"
}
variable "routeTable_cidr" {
	default = "0.0.0.0/0"
}