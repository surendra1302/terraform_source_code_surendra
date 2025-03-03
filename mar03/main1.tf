# AWS Provider
provider "aws" {
  region = var.aws_region
  access_key = "AKIAZPPGAEC7NH52K6QV"
  secret_key = "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"
}

# Variables
variable "aws_region" {
  description = "The AWS region where the EC2 instance will be created."
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The type of EC2 instance to launch."
  type        = string
  default     = "t2.micro"
}

variable "tag_prefix" {
  description = "Prefix to use for the Name tag of the EC2 instance."
  type        = string
  default     = "MyServer"
}

# Data source to get the latest Amazon Linux 2 AMI
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Data source to get the default VPC
data "aws_vpc" "default_vpc" {
  default = true
}

# Local values for common tags
locals {
  creation_date = formatdate("DD-MM-YYYY", timestamp())

  common_tags = {
    "Name"         = "${var.tag_prefix}-EC2-${local.creation_date}"
    "Environment"  = "Development"
    "Team"         = "DevOps"
    "Created_On"   = local.creation_date
  }
}

# EC2 Instance
resource "aws_instance" "example_instance" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  tags          = local.common_tags
}

# Outputs
output "ami_id" {
  description = "The ID of the AMI used for the EC2 instance."
  value       = data.aws_ami.latest_amazon_linux.id
}

output "vpc_id" {
  description = "The ID of the default VPC."
  value       = data.aws_vpc.default_vpc.id
}
