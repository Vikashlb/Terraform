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

resource "aws_instance" "student_app" {
  ami                    = "ami-0e449927258d45bc4"
  instance_type          = "t2.micro"
  key_name               = "StudentAppKey"
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  provisioner "remote-exec" {
    inline = [
      "sudo dnf install java-21-amazon-corretto -y",
      "sudo dnf install git -y",
      "sudo dnf install maven -y",
      "git clone ${var.repo_url}",
      "export JAVA_HOME=/usr/lib/jvm/java-21-amazon-corretto",
      "export PATH=$JAVA_HOME/bin:$PATH",
      "cd StudentApp/student",
      "mvn clean install"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("C:/Users/VBOJARAJAN/Downloads/StudentAppKey.pem")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "Student Clone"
  }
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value = aws_instance.student_app.public_ip
}