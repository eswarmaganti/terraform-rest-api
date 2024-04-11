# Security Group Id of public bation server
output "public_bation_sg_id" {
  value = aws_security_group.security_group_public_bation.id
}

# Security Group id of Private Application 
output "app_sg_id" {
  value = aws_security_group.app_security_group.id
}

# Security Group id of RDS MySQL server
output "docdb_sg_id" {
  value = aws_security_group.security_group_docdb.id
}
