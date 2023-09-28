# Create the VPC
resource "aws_vpc" "cluster_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a public subnet associated with the Internet Gateway
resource "aws_subnet" "public_subnet" {
  vpc_id             = aws_vpc.cluster_vpc.id
  cidr_block         = "10.0.1.0/24"
  availability_zone  = "us-east-1a"
  map_public_ip_on_launch = true  # This enables instances in this subnet to get public IPs
}

# Create a private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id             = aws_vpc.cluster_vpc.id
  cidr_block         = "10.0.2.0/24"
  availability_zone  = "us-east-1b"
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cluster_vpc.id
}

# Create the bastion host
resource "aws_instance" "bastion_host" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = "clase_key"
  associate_public_ip_address = true  # Ensure a public IP is assigned

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y curl wget unzip 
    sudo apt-get install -y git 
    sudo apt-get install python3 python3-pip -y
    sudo apt-get install -y openssh-server
    sudo systemctl start sshd
    sudo systemctl enable sshd
  EOF

  tags = {
    Name = "bastion"
  }

  # Create a security group for the bastion host allowing SSH access
  security_groups = [
    aws_security_group.bastion_sg.id
  ]
}

# Create two instances in the private subnet
resource "aws_instance" "private_instance1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet.id
  key_name               = "clase_key"
  associate_public_ip_address = false  # Private instances do not need a public IP

  user_data = <<-EOF
    #!/bin/bash
    # Configure your private instance here
    echo "Private instance 1 configured." >> /tmp/private_instance.log
  EOF

  tags = {
    Name = "private_instance1"
  }

  # Allow SSH access from the bastion host
  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]
}

resource "aws_instance" "private_instance2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet.id
  key_name               = "clase_key"
  associate_public_ip_address = false  # Private instances do not need a public IP

  user_data = <<-EOF
    #!/bin/bash
    # Configure your private instance here
    echo "Private instance 2 configured." >> /tmp/private_instance.log
  EOF

  tags = {
    Name = "private_instance2"
  }

  # Allow SSH access from the bastion host
  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]
}

# Security group for the bastion host allowing SSH access
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.cluster_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for the private instances allowing SSH access from the bastion host
resource "aws_security_group" "private_instance_sg" {
  vpc_id = aws_vpc.cluster_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
}