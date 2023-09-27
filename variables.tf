variable "aws_region" {
  description = "AWS region for EC2 instances"
  default     = "us-east-1"
}

variable "ami_id" {
  default     = "ami-053b0d53c279acc90"  # Replace with the appropriate AMI ID
  description = "Amazon Machine Image (AMI) ID for the instances"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.small"
}

variable "key_name" {
  default     = "clase_key"
  description = "Name of the existing EC2 key pair to associate with the instances"
}