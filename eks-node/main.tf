resource "aws_eks_node_group" "main" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids
  instance_types  = var.instance_types
  labels          = var.labels

  remote_access {
    ec2_ssh_key               = var.ec2_ssh_key
    source_security_group_ids = var.source_security_group_ids
  }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  tags = var.tags
}

output "arn" {
  value = aws_eks_node_group.main.arn
}

output "id" {
  value = aws_eks_node_group.main.id
}