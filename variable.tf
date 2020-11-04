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
variable "bucketname"{
	description="Name of the bucket _ ex: webapp.fname.lname"
}
variable "db_instance_class"{
	description="Instance Class for the Database Server"
	default = "db.t3.micro"
}
variable "db_identifier"{
	description= "The name of the RDS instance "
	default = "csye6225-f20"
}
variable "db_username"{
	description= "Master Username for the DB"
	default = "csye6225fall2020"
}
variable "db_password"{
	description= "Master Password for the DB"
}
variable "terminate"{
	default="terminate"
}
variable "dbname"{
	description= "Name of the DB to be created in the RDS instance"
	default = "csye6225"
}
variable "db_subnet_group"{
	description = " This subnet group will ensure the RDS instace is created in the same vpc"
	default = "db_subnet_group"
}
variable "ec2_instance_type"{
	description="Instance Type for the App Server"
	default = "t2.micro"
}
variable "db_engine"{
	default="mysql"
}
variable "encryption_algorithm"{
	default="AES256"
}
variable "keyname"{
	default="webapp1"
}
variable "ami_id"{
	description = "AMI id of the custom AMI built using packer"
}
variable "dynamodb_name"{
	description = "Name of the Dynamo DB table"
	default="csye6225"
}
variable "s3policyName"{
	default = "WebAppS3"
}
variable "bucketARN"{
	default="arn:aws:s3:::webapp.deepak.gopalan/*"
}
variable "s3roleName"{
	default="EC2-CSYE6225"
}
variable "ec2InstanceProfile"{
	default="ec2-s3-profile"
}
variable "codedeploy_bucket_arn"{
	description = "Enter the bucket ARN"
}

variable "codedeploy_bucket_arn_star"{

}
variable "CodeDeploy-EC2-S3"{
	default="CodeDeploy-EC2-S3"
}
variable "GH-Upload-To-S3"{
	default="GH-Upload-To-S3"
}

variable "ghactions_username"{
	default="ghactions"
}

variable "GH-Code-Deploy"{
	default= "GH-Code-Deploy"
}

variable "CodeDeployEC2ServiceRole"{
	default="CodeDeployEC2ServiceRole"
}

variable "CodeDeployServiceRole"{
	default="CodeDeployServiceRole"
}

variable "account_id"{

}

variable "CodeDeployServiceRole_policy"{
	default="arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

variable "codedeploy_appname"{
	default="csye6225-webapp"
}

variable "codedeploy_group"{
	default="csye6225-webapp-deployment"
}

variable "zoneId"{
	description = "Enter the ZoneId of the hosted Zone"

}
variable "route53_record_name"{
	description = "Enter Record Name ex: api.dev.domainname.tld"

}
