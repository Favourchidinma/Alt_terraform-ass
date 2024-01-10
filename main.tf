#Provider block for instance 1
provider "aws" {
  region = "eu-north-1"
}


#VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}


#subnet
resource "aws_subnet" "my_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.subnet_cidr

  tags = {
    Name =var.subnet_name
  }
}


#Creates a gateway to the internet
resource "aws_internet_gateway" "my_ig" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = var.igw_name
  }
}


#creates a route table with the IGW
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_ig.id
  }

  tags = {
    Name = var.igw_name
  }
}


#Associate route table with subnet
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


#Creates new security group open to HTTP traffic
resource "aws_security_group" "app_sg" {
  name = "HTTP"
  vpc_id = aws_vpc.my_vpc.id

  #Inbound rule allowing HTTP access
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #Outbound rule allowing all traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#Creating EC2 instance 
resource "aws_instance" "region" {
  ami     = var.EC2_ami
  instance_type = "t3.micro"
  tags = {
    Name = "aws_ass"
  }
}


################################ INSTANCE 2 ################################

#Provider block for instance 2
provider "aws" {
  alias = "MyPrac1"
  region = "eu-west-1"
}


#VPC
resource "aws_vpc" "my_vpc1" {
  cidr_block = var.vpc_cidr1

  tags = {
    Name = var.vpc_name
  }
}


#subnet
resource "aws_subnet" "my_subnet1" {
  vpc_id = aws_vpc.my_vpc1.id
  cidr_block = var.subnet_cidr1

  tags = {
    Name =var.subnet_name1
  }
}


#Creates a gateway to the internet
resource "aws_internet_gateway" "my_ig1" {
  vpc_id = aws_vpc.my_vpc1.id

  tags = {
    Name = var.igw_name1
  }
}


#creates a route table with the IGW
resource "aws_route_table" "public_rt1" {
  vpc_id = aws_vpc.my_vpc1.id

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_ig1.id
  }

  tags = {
    Name = var.igw_name1
  }
}


#Associate route table with subnet
resource "aws_route_table_association" "public_rt_assoc1" {
  subnet_id = aws_subnet.my_subnet1.id
  route_table_id = aws_route_table.public_rt1.id
}


#Creates new security group open to HTTP traffic
resource "aws_security_group" "app_sg1" {
  name = "HTTP"
  vpc_id = aws_vpc.my_vpc1.id

  #Inbound rule allowing HTTP access
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #Outbound rule allowing all traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}


data "aws_ami" "region1" {
  most_recent = true
  owners      = ["099720109477"] 

  filter {
    name   = "name"  
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]  
  }
}


resource "aws_instance" "region1" {
  ami     = data.aws_ami.region1.id
  instance_type = "t3.micro"

  subnet_id  = aws_subnet.my_subnet1.id
  security_groups = [
    aws_security_group.app_sg1.id
  ]
  
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y software-properties-common
              apt-add-repository --yes --update ppa:ansible/ansible
              apt-get install -y ansible
              
              # Install Docker
              apt-get update -y
              apt-get install -y apt-transport-https ca-certificates curl software-properties-common
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
              add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
              apt-get update -y
              apt-get install -y docker-ce docker-ce-cli containerd.io
              
              systemctl enable docker
              systemctl start docker
              EOF


  tags = {
    Name = "aws_ass1"
  }
            

}


