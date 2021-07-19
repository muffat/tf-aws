resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.role_arn
  version  = var.kubernetes_version
  tags     = var.tags

  vpc_config {
    subnet_ids         = var.subnets
    security_group_ids = var.cluster_security_group_ids
  }
}

output "endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "arn" {
  value = aws_eks_cluster.main.arn
}

output "id" {
  value = aws_eks_cluster.main.id
}