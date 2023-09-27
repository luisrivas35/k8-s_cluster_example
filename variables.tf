variable "aws_region" {
  description = "AWS region for EC2 instances"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Amazon Machine Image (AMI) ID for the instances"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.small"
}
