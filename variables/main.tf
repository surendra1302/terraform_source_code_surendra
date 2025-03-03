provider "aws" {
  region = var.aws_region
}

# Data sources to fetch default VPC ID and latest AMI

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
   filter {
    name   = "availability-zone"
    values = ["${var.aws_region}a"]
  }
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
#locals
locals {
  creation_date = formatdate("YYYYMMDD", timestamp())
  common_tags = {
    Project  = var.tag_prefix
    Created  = local.creation_date
    Owner    = "Devops_Engineer"
  }
  instance_name = "${var.tag_prefix}-ec2-${local.creation_date}"
}
# EC2 Instance resource
resource "aws_instance" "example" {
  ami             = data.aws_ami.latest_amazon_linux.id
  instance_type   = var.instance_type
  subnet_id       = data.aws_subnet.default_subnet.id
  tags = merge(local.common_tags, { Name = local.instance_name })
}

output "instance_id" {
  value = aws_instance.example.id
}
