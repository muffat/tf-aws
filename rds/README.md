# tf-aws/rds
A terraform module which provisions a RDS clsuter.

# Usage

```HCL
module "rds" {
    source              = "muffat/tf-aws/rds"
    cluster_identifier  = "aurora-cluster"
    availability_zones  = ["us-east-1a", "us-east-1b"]
    database_name       = "my-database"
    master_username     = var.master_username
    master_password     = var.master_password
    instance_class      = "db.t2.micro"
    subnet_ids          = ["subnet-123", "subnet-124"]
}
```