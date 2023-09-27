resource "aws_vpc" "cluster_vpc" {
  cidr_block = "10.0.0.0/16"  # Replace with your desired CIDR block
}

resource "aws_subnet" "cluster_subnet" {
  vpc_id                  = aws_vpc.cluster_vpc.id
  cidr_block              = "10.0.1.0/24"  # Replace with your desired CIDR block for the subnet
  availability_zone       = "us-east-1a"  # Replace with your desired AZ
}

resource "aws_instance" "instance1" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.cluster_subnet.id
}

resource "aws_instance" "instance2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.cluster_subnet.id
}


