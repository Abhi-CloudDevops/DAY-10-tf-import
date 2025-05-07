# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# variables.tf
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "allow_ssh_from" {
  description = "Allowed IP for SSH access"
  type        = string
  default     = "0.0.0.0/0" # Restrict this in production!
}

# security.tf
resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg-"
  description = "Allow HTTP and limited SSH access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allow_ssh_from]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Terraform = "true"
  }
}

# ec2.tf
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = file("user-data.sh")

  tags = {
    Name = "web-server"
  }

  monitoring    = true
  associate_public_ip_address = true
}

# user-data.sh
#!/bin/bash
set -ex
yum update -y
yum install -y httpd
echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd

# outputs.tf
output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.web_sg.id
}
