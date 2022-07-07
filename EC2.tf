resource "random_pet" "sgc" {}
  
  resource "aws_vpc" "awsec2demo" {
    cidr_block = "172.16.0.0/16"

    tags = {
      "Name" = "vpc-quickcloudpocs"
    }
  }

  resource "aws_subnet" "awsec2demo" {
    vpc_id = aws_vpc.awsec2demo.id
    cidr_block = "172.16.10.0/24"
    tags = {
      "Name" = "subnet-qucikcloudpocs"
    }
  }

  resource "aws_network_interface" "awsec2demo" {
    subnet_id = aws_subnet.awsec2demo.id
    private_ips = ["172.16.10.0.100"]
    tags = {
      "Name" = "Network-Interface"
    }
    
  }

resource "aws_security_group" "awsec2demo" {
    name = "${random_pet.sg.id}-sg"
    vpc_id = aws_vpc.awsec2demo.id
    ingress = {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "awsec2demo" {
    ami = "ami-08df646e18b182346"
    instance_type = "t2.micro"
   
    network_interface {
        network_interface_id = aws_network_interface.awsec2demo.id
        device_index = 0
    }
}
