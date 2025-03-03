provider "aws" {
    
   access_key = "AKIAZPPGAEC7NH52K6QV"
   secret_key = "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"
   region = var.aws_region
}

locals {
  creation_time = formatdate("YYYY-MM-DD HH:MM", timestamp())
  common_tags = {
    Owner        = "DevOps Team"
    Environment  = "Testing"
    Created_At   = local.creation_time
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]  

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  

  tags = {
    Name = "${var.tag_prefix}-${var.instance_type}-${local.creation_time}"
  }
}


output "instance_id" {
  value = aws_instance.example.id
}

output "public_ip" {
  value = aws_instance.example.public_ip
}

output "instance_name" {
  value = aws_instance.example.tags["Name"]
}

