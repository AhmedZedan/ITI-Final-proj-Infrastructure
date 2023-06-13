output "bastion_private_id" {
  value = aws_instance.bastion_server.private_ip
}

output "bastion_public_id" {
  value = aws_instance.bastion_server.public_ip
}