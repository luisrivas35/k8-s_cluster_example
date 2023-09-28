# Outputs
output "vpc_id" {
  value = aws_vpc.cluster_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "bastion_host_id" {
  value = aws_instance.bastion_host.id
}

output "bastion_host_public_ip" {
  value = aws_instance.bastion_host.public_ip
}

output "bastion_security_group_id" {
  value = aws_security_group.bastion_sg.id
}

output "private_instance_security_group_id" {
  value = aws_security_group.private_instance_sg.id
}
