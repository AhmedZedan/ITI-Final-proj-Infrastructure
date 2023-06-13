output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "pub_sub_id" {
  value = aws_subnet.public_sub[*].id
}

output "priv_sub_id" {
  value = aws_subnet.private_sub[*].id
}