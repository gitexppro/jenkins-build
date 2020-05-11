# variable "aws_access_key" {}
# variable "aws_secret_key" {}
variable "aws_region" {}

variable "vpc_cidr" {}
variable "vpc_name" {}

variable "public_subnet1_cidr" {}

variable "public_subnet1_name" {}

variable "az1" {
  default = "us-east-1a"
}

# variable "public_subnet2_cidr" {}

variable "az2" {
  default = "us-east-1b"
}

# variable "public_subnet2_name" {}

variable "IGW_name" {}

variable "Main_Routing_Table" {}












