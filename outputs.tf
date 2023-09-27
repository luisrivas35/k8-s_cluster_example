output "instance1_public_ip" {
  value = aws_instance.instance1.public_ip
}

output "instance2_public_ip" {
  value = aws_instance.instance2.public_ip
}

output "bastion_host_public_ip" {
  value = aws_instance.bastion_host.public_ip
}
