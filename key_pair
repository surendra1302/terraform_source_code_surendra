#Using Terraform to create an Ubuntu EC2 instance with a security group and a PEM key, and configure user data to unzip and host a static website using an HTTP server
provider "aws" {
  region     = "us-east-2"
}

# Generate Key Pair Locally
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "deployer" {
  key_name   = "my-key"
  public_key = tls_private_key.my_key.public_key_openssh
}

# Save Private Key Locally
resource "local_file" "private_key" {
  content  = tls_private_key.my_key.private_key_pem
  filename = "${path.module}/my-key.pem"
}

# Security Group for EC2
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow inbound HTTP and SSH"

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change this to your IP for security
  }

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0cb91c7de36eed2cb"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = ["${aws_security_group.web_sg.name}"]

  # User Data Script to Install Apache, Unzip, and Host Website
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y apache2 unzip wget
              sudo systemctl start apache2
              sudo systemctl enable apache2
              cd /var/www/html
              sudo wget -O website.zip https://www.free-css.com/assets/files/free-css-templates/download/page296/carvilla.zip
              sudo unzip website.zip
              sudo mv */* .
              sudo rm -rf website.zip
              sudo systemctl restart apache2
              EOF

  tags = {
    Name = "UbuntuWebServer"
  }
}
