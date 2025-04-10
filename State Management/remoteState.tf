 terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
   backend "s3" {
    bucket         = "bucket-name"
    key            = "dev/terraform.tfstate"   # relative path inside bucket
    region         = "us-east-1"
    dynamodb_table = "terraform-locks-table"         # optional, for state locking
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "student" {
  ami           = "ami-00a929b66ed6e0de6"
  instance_type = "t2.micro"
  tags = {
    Name = "student"
  }
}