resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.role_arn
  version  = var.version
  tags     = var.tags

  vpc_config {
    subnet_ids         = var.subnets
    security_group_ids = var.cluster_security_group_ids
  }
}

resource "aws_iam_role" "example" {
  name = "eks-cluster-example"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
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