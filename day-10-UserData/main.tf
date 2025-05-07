provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "my_instance" {
  ami                    = "ami-062f0cc54dbfd8ef1" 
  instance_type          = "t2.micro"              
  associate_public_ip_address = true                
#   key_name               = "my-key-pair"           
  
 vpc_security_group_ids = [aws_security_group.my_security_group.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              echo "Hello, World!" > /var/www/html/index.html
              systemctl start httpd
              systemctl enable httpd
            EOF
}

resource "aws_security_group" "my_security_group" {
  name        = "my_security_group"
  description = "Allow HTTP access"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from any IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}



