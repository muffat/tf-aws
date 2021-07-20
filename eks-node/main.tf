/*resource "random_string" "random" {
  keepers = {
    name = var.node_group_name
  }
  special = false
  length  = 8
}*/

data "template_file" "main" {
  template = <<EOF
  #!/bin/bash
  set -ex
  B64_CLUSTER_CA=LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM1ekNDQWMrZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeE1EY3lNREE0TWpVME9Wb1hEVE14TURjeE9EQTRNalUwT1Zvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBT01MCllUdVl5WmRiU2VMKzVjVFl5U1l1TEJka0wvdDE5aVI1R3ZEaXExN3dqNUx0U3ZwalhzT0VEQWRqWDAvK2EvU3kKSWlHMHZCNHpjeXlCWFVpMDVwWitpNEhGU3UxOHhJNXgrYmw3VG4reDA0NW9Ja3JpamhJcnFPRUhleWhSN2oycApIVUNsQ2loVzR5ZUhXdG56UnB3UEhYaFBxckNDNTMyd2Y4TW5Xd1o5YTZNcFlWN2JtaS9jSERqbkVxbVJoRVdtCkJJTTVDZEFBNW5Ud2s2eHBUV0E3RSsrOWlVemFoL3hIaWFqL1BhUzJZcEhyRiszeThNRE5KUU9QaEdqZWlYNkQKQ1VvNDYrTmd4eGh3dDY3VFpXU0FXamYveVhuVk9pai9wek9CM0VEWnlKek5BcXUyV2hUNzMwRWNROUpDZjNwSwphZklSb2lkRFNFRXN6VTRMR3BNQ0F3RUFBYU5DTUVBd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZEMENCZ0lNeUFZSXNlOHNKRzhKeFRNcWZRSHhNQTBHQ1NxR1NJYjMKRFFFQkN3VUFBNElCQVFDSjlDOHJYKzd0N1dBRFVXTXJRMXRNSnZXM1NOZDRBcS9BN1pkU3ZDNkNWdk5jMENzTApWQjMrbVdmVWxvdGtic1M1bEp0djRObEtCSkN6RHhHRlJ3aTJXMExrN0p1NHBBVTd1aHQ2NWpLY3FpeFN5Vk5sCm5Ib2Ftc1k2RHZHN0lENmtWWHA0SkFoN0N0TGYrUHBNVHU1bDFKWjVxVDYzZU1CdFdFaDhWVlZYamlOcjIyZDgKczc0VVA3aGhyS25XVGE5WERFdDBmRWZkVCsvODljS1RTR1NRdFBkQWE0YlBQKzNIQlNkVVkvUFFoQXR5UFozTwpRRTdXYXVXdHdieWJ4NlM1cTJHcDNsNFBXNFJEL0VBcG5KZkFLVXhIRnRoUUcwUUp0djZldEt0aTlvNmlyd0dBCnRDY1NjL1BCTm9ia1h2Wi9GdjdacnQ5S1dqLzhPT2VZMS8yMgotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
  API_SERVER_URL=https://6412C86CC363FDF0E0F3E0B9875FDEC5.gr7.ap-southeast-1.eks.amazonaws.com
  K8S_CLUSTER_DNS_IP=10.100.0.10
  /etc/eks/bootstrap.sh airflow --kubelet-extra-args '--node-labels=eks.amazonaws.com/nodegroup-image=ami-07d07629a4f622bb9,eks.amazonaws.com/capacityType=ON_DEMAND,eks.amazonaws.com/nodegroup=airflow' --b64-cluster-ca $B64_CLUSTER_CA --apiserver-endpoint $API_SERVER_URL --dns-cluster-ip $K8S_CLUSTER_DNS_IP
  EOF
}

resource "aws_launch_template" "main" {
  name          = "lt-eks-${var.node_group_name}"
  image_id      = "ami-07d07629a4f622bb9"
  instance_type = "t2.micro"
  key_name      = "aws-oasis"

  user_data = "${base64encode(data.template_file.main.rendered)}"
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