resource "random_string" "random" {
  keepers = {
    name = var.node_group_name
  }
  special = false
  length  = 8
}

resource "aws_launch_template" "main" {
  name          = "${var.node_group_name}-${random_string.random.id}"
  image_id      = "ami-07d07629a4f622bb9"
  instance_type = "t2.micro"
  key_name      = "aws-oasis"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 20
      volume_type           = "gp2"
      delete_on_termination = true
      iops                  = 0
    }
  }

  tags = {
    "eks:cluster-name" : var.cluster_name
    "eks:nodegroup-name" : var.node_group_name
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids
  instance_types  = var.instance_types
  labels          = var.labels

  launch_template {
    id      = aws_launch_template.main.id
    version = 1
  }

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