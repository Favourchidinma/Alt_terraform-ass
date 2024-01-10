variable enviroment {
    default = "dev"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  default = "vpc_alt"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "subnet_name" {
  default = "subnet_alt"
}

variable "igw_name" {
  default = "igw_alt"
}

variable "EC2_ami" {
  default = "ami-0fe8bec493a81c7da"
}

variable "subnet_cidr1" {
  default = "10.1.1.0/24"
}

variable "subnet_name1" {
  default = "subnet_alt1"
}

variable "igw_name1" {
  default = "igw_alt1"
}

variable "vpc_cidr1" {
  default = "10.1.0.0/16"
}

#variable "EC2_ami1" {
  #default = "ami-0e5f882be1900e43b"
#}