resource "aws_rds_cluster_instance" "default" {
  count              = var.instance_count
  identifier         = "${aws_rds_cluster.default.cluster_identifier}-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.default.id
  instance_class     = var.instance_class
}

resource "aws_rds_cluster" "default" {
  cluster_identifier   = var.cluster_identifier
  availability_zones   = var.availability_zones
  database_name        = var.database_name
  master_username      = var.master_username
  master_password      = var.master_password
  db_subnet_group_name = aws_db_subnet_group.default.name
}

resource "aws_db_subnet_group" "default" {
  name        = "${var.cluster_identifier}-subnetgroup"
  description = "${var.cluster_identifier} default subnet group"
  subnet_ids  = var.subnet_ids
}