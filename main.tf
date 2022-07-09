terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.50.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  cloud {
    organization = "terraform-organisation-1997"

    workspaces {
      name = "terraform-workflow-1997"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  profile = "default"
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
}


resource "aws_instance" "web" {
  ami                    = "ami-08df646e18b182346"
  instance_type          = "t2.micro"
  availability_zone = "ap-south-1a"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  tags = {
    "Name" = "Terraform-Githubactions-EC2"
  }
}

resource "aws_security_group" "web-sg" {
  name = "my-security-group" {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // connectivity to ubuntu mirrors is required to run `apt-get update` and `apt-get install apache2`
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "web-address" {
  value = "${aws_instance.web.public_dns}:8080"
}
