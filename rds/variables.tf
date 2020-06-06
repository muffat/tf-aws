variable "instance_count" {
  default     = 2
  type        = number
  description = "Number instances"
}

variable "cluster_identifier" {
  type        = string
  description = "Name for cluster"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones"
}

variable "database_name" {
  type        = string
  description = "Name for database"
}

variable "master_username" {
  type        = string
  description = "Name for master username"
}

variable "master_password" {
  type        = string
  description = "Name for master password"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet id"
}

variable "instance_class" {
  type        = string
  description = "Instance type for rds"
}