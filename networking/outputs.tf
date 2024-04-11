
# output variables decleration
output "vpc_id" { value = aws_vpc.app_vpc.id }
output "public_subnet_ids" {
  value = [for subnet in aws_subnet.app_vpc_public_subnets : subnet.id]
}
output "private_subnet_ids" {
  value = [for subnet in aws_subnet.app_vpc_private_subnets : subnet.id]
}
output "nat_gateway" {
  value = aws_nat_gateway.nat_gtw
}
output "docdb_subnet_group_id" {
  value = aws_docdb_subnet_group.doocdb_subnet_group.id
}
