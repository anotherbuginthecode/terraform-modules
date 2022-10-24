output "sg_arn" {
  value = one(aws_security_group.ec2_sg[*].arn)
}