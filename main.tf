resource "aws_vpc" "cluster_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.cluster_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.cluster_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
}

resource "aws_instance" "bastion_host" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = "clase_key"

  tags = {
    Name = "bastion"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y curl wget unzip 
    sudo apt-get install -y git 
    sudo apt-get install python3 python3-pip -y
  EOF
}

resource "aws_instance" "instance1" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private_subnet.id
  key_name      = "clase_key"

  tags = {
    Name = "master"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y curl wget unzip 
    sudo apt-get install -y git 
    sudo apt-get install python3 python3-pip -y
  EOF
}

resource "aws_instance" "instance2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private_subnet.id
  key_name      = "clase_key"

  tags = {
    Name = "worker"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y curl wget unzip 
    sudo apt-get install -y git 
    sudo apt-get install python3 python3-pip -y
  EOF
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

# Associate the security group with the bastion host
resource "aws_instance" "bastion_host" {
  security_groups = [aws_security_group.bastion_sg.id]
}

# Associate the security group with the private instances
resource "aws_instance" "instance1" {
  security_groups = [aws_security_group.private_instance_sg.id]
}

resource "aws_instance" "instance2" {
  security_groups = [aws_security_group.private_instance_sg.id]
}
