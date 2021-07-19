variable "cluster_name" {}
variable "node_group_name" {}
variable "node_role_arn" {}
variable "subnet_ids" {}
variable "instance_types" {}
variable "labels" {
  default = {}
}
variable "ec2_ssh_key" {}
variable "source_security_group_ids" {}
variable "desired_size" {}
variable "max_size" {}
variable "min_size" {}
variable "tags" {}