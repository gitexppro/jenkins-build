
#Terraform HCL code to deply basic AWS VPC

provider "aws" {                                  #aws cloud
  # access_key = "${var.aws_access_key}"
  # secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}

terraform{
  backend "s3" {
    bucket = "devops-prac"
    key = "statefile.tfstate"
    region = "us-east-1"
  }
}
resource "aws_vpc" "main" {                       #aws vpc creation
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.vpc_name}"
    Env = "Prod"
  }
}

resource "aws_subnet" "subnet1-public" {          #creating subnet1-public in vpc "main"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.public_subnet1_cidr}"
  availability_zone = "${var.az1}"

  tags = {
    Name = "${var.public_subnet1_name}"
  }
}

# resource "aws_subnet" "subnet2-public" {
#   vpc_id = "${aws_vpc.main.id}"
#   cidr_block = "${var.public_subnet2_cidr}"
#   availability_zone = "${var.az2}"  

#   tags = {
#     Name = "${var.public_subnet2_name}"
#   }
# }

resource "aws_internet_gateway" "IGW" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${var.IGW_name}"
  }
}

resource "aws_route_table" "ROUTE" {
  vpc_id = "${aws_vpc.main.id}"

   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.IGW.id}"
  }

  tags = {
    Name = "${var.Main_Routing_Table}"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id = "${aws_subnet.subnet1-public.id}"
  route_table_id  = "${aws_route_table.ROUTE.id}"

}

resource "aws_instance" "web-1" {
    # ami = "${data.aws_ami.my_ami.id}"
    ami = "ami-0915e09cc7ceee3ab"
    availability_zone = "us-east-1a"
    instance_type = "t2.micro"
    key_name = "Mkeypair"
    subnet_id = "${aws_subnet.subnet1-public.id}"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address = true	
    tags = {
        Name = "Server-1"
        Env = "Prod"
        
    }
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    description = "all from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all"
  }
}


