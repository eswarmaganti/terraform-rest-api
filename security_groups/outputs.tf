# Security Group Id of public bation server
output "public_bation_sg_id" {
    value = aws_security_group.security_group_public_bation.id
}

# Security Group id of Private Application 
output "private_application_sg_id" {
    value = aws_security_group.security_group_application.id
}

# Security Group id of RDS MySQL server
output "rds_mysql_sg_id" {
    value = aws_security_group.security_group_rds_mysql.id
}