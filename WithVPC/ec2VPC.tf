terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "student_instance" {
  ami           = ""
  instance_type = "t2.micro"
  tags = {
    Name = "studentInstance"
  }
}

resource "aws_vpc" "student_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "studentVpc"
  }
}

resource "aws_subnet" "student_subnet" {
  vpc_id                  = aws_vpc.student_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "studentSubnet"
  }
}

resource "aws_internet_gateway" "student_igw" {
  vpc_id = aws_vpc.student_vpc.id
  tags = {
    Name = "studentInternetGateway"
  }
}

resource "aws_route_table" "student_route_table" {
  vpc_id = aws_vpc.student_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.student_igw.id
  }
  tags = {
    Name = "studentRouteTable"
  }
}

resource "aws_route_table_association" "student_route_table_association" {
  route_table_id = aws_route_table.student_route_table.id
  subnet_id      = aws_subnet.student_subnet.id
}
