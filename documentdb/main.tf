resource "aws_docdb_cluster" "docdb_cluster" {
  cluster_identifier     = var.docdb_cluster_name
  engine                 = "docdb"
  port                   = var.docdb_port
  master_username        = var.docdb_master_username
  master_password        = var.docdb_master_password
  vpc_security_group_ids = var.docdb_sg_ids
  availability_zones     = var.availability_zones
  db_subnet_group_name   = var.docdb_subnet_group_id
  skip_final_snapshot = true
}

resource "aws_docdb_cluster_instance" "docdb_instance" {
  count              = 1
  cluster_identifier = aws_docdb_cluster.docdb_cluster.id
  identifier         = "${var.docdb_cluster_name}-${count.index}"
  instance_class     = var.db_instance_class
}
