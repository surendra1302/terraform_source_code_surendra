variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "tag_prefix" {
  description = "Prefix for resource tags"
  type        = string
  default     = "myapp"
}
