provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0d176f79571d18a8f"
  instance_type = "t3.micro"

  tags = {
    Name  = "Jenkins-Server"
    Owner = "Abhishek"
    Note  = "Server created by Jenkins"
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    echo "Hello from Jenkins Deployment!" > /var/www/html/index.html
    systemctl start httpd
    systemctl enable httpd
  EOF
}

