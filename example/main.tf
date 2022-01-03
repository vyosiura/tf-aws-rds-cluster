module "aurora-cluster" {
    source                  = "../"
    cluster_identifier      = "testing-tf-cluster-rds"
    engine                  = "aurora-mysql"
    engine_version          = "8.0.mysql_aurora.3.01.0"
    parameter_group_family  = "aurora-mysql8.0"
    master_password         = "askdjdojoij213"
    master_username         = "root-user"
    vpc_id                  = "vpc-12381asd123"
    db_subnet_group_name    = "subnet-group-name"
    backtrack_window        = 0 // aurora-mysql 3.0 doesn't support backtrack for now
    deletion_protection     = false
    apply_immediately       = true
    tags                    = { 
        "Engine"              = "aurora-mysql"
        "EngineVersion"       = "aurora-mysql.3.01"
        "Terraform"           = "true"
    }
}
