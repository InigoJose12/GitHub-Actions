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
  name = "my-security-group" 
  ingress = [ {
    cidr_blocks = ["0.0.0.0/0"]
    description = "my-inbound rules"
    from_port = 8080
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    protocol = "tcp"
    security_groups = []
    self = false
    to_port = 8080
  } ]
  egress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "outbound-rules"
    from_port = 0
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    protocol = "-1"
    security_groups = []
    self = false
    to_port = 0
  } ]
  // connectivity to ubuntu mirrors is required to run `apt-get update` and `apt-get install apache2`
  
}

output "web-address" {
  value = "${aws_instance.web.public_dns}:8080"
}
