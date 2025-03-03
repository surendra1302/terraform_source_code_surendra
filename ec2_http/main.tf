#	Create a vpc, create public subnet, launch ec2 instance inside the vpc, security group,
#	Security group should allow ssh and 443 access for that instance and  map that security group to the EC2 instance.
#	Variabalize resources, define variables in variables.tf and values in the custom.tfvars file.

provider "aws" {
 #Access key and secret key are not needed
 #refers from the environment variables
  region     = var.aws_region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "MyVPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone

  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.my_vpc.id

  # Allow SSH (port 22) from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS (port 443) from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
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

  tags = {
    Name = "WebSecurityGroup"
  }
}

resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "NewWebServer"
  }
}
