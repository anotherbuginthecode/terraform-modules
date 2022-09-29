output "bastion-security-group-id" {
  description = "Bastion Host security group"
  value       = aws_security_group.bastion.id
}

output "bastion-ip" {
    value = aws_instance.bastion.instance_public_ip
}