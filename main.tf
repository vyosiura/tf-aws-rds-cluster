locals {
  scaling_configuration = [{
      timeout_action            = var.scaling_configuration_timeout_action
      auto_pause                = var.scaling_configuration_auto_pause
      seconds_until_auto_pause  = var.scaling_configuration_seconds_until_auto_pause
      max_capacity              = var.scaling_configuration_max_capacity
      min_capacity              = var.scaling_configuration_min_capacity
  }]
  scale_config = var.engine_mode == "serverless" ? local.scaling_configuration : []

  pit_configuration = [{
      source_cluster_identifier       = var.pit_source_cluster_identifier
      restore_type                    = var.pit_restore_type
      use_latest_restorable_time      = var.pit_use_latest_restorable_time
      restore_to_time                 = var.pit_restore_to_time
  }]
  pit_config = var.restore_pit ? local.pit_configuration : []

  cluster_identifier = lower(var.cluster_identifier != null ? var.cluster_identifier : var.cluster_identifier_prefix)
  final_snapshot_identifier = var.final_snapshot_identifier == null ? "${local.cluster_identifier}-final-snapshot" : var.final_snapshot_identifier

  engine_port = {
    aurora              = 3306
    aurora-mysql        = 3306
    aurora-postgresql   = 5432
  }
  port = var.port == null ? lookup(local.engine_port, var.engine) : var.port
  vpc_security_group_ids = var.vpc_security_group_ids == null ? [] : var.vpc_security_group_ids
  pg_name = (var.engine == "aurora-postgresql" ? 
      join("",slice(split(".", var.parameter_group_family), 0, 1)) : 
      join("",slice(split(".", var.parameter_group_family), 0, 2))
  )
  db_cluster_parameter_group_name = var.db_cluster_parameter_group_name == null ? "${local.cluster_identifier}-${local.pg_name}" : var.db_cluster_parameter_group_name
}


/*

      RESOURCES

*/
resource "aws_db_subnet_group" "cluster" {
  count                                     = var.create_subnet_group ? 1 : 0
  name                                      = var.db_subnet_group_name
  subnet_ids                                = var.subnet_ids
  description                               = "Subnet group created for ${local.cluster_identifier}"
  tags                                      = var.tags
}


resource "aws_rds_cluster_parameter_group" "cluster" {
  name                                      = local.db_cluster_parameter_group_name
  family                                    = var.parameter_group_family
  description                               = "Parameter group serving - ${local.cluster_identifier}"
  dynamic "parameter" {
      for_each    = var.parameters

      content {
        name            = parameter.value["name"]
        value           = parameter.value["value"]
        apply_method    = lookup(parameter.value, "apply_method", "immediate")
      }
  }
  tags                                      = var.tags
}

resource "aws_security_group" "cluster" {
  count                                     = var.create_security_group ? 1 : 0
  name                                      = "${local.cluster_identifier}-sg"
  vpc_id                                    = var.vpc_id
  description                               = "Security group for Aurora Cluster - ${local.cluster_identifier}"

  ingress {
    cidr_blocks       = var.cidr_blocks
    description       = "Inbound rules"
    from_port         = local.port
    to_port           = local.port
    ipv6_cidr_blocks  = null
    prefix_list_ids   = null
    protocol          = "tcp"
    security_groups   = var.security_groups
    self              = false
  }

  egress {
      cidr_blocks     = [ "0.0.0.0/0" ]
      description     = "Outbound rule"
      from_port       = 0
      to_port         = 0
      protocol        = "tcp"
      self            = false
  }
  tags                                        = var.tags 
  lifecycle {
    create_before_destroy = true
  }
}



# resource "aws_route53_record" "endpoint" {
#   zone_id                                   = var.zone_id 
#   name                                      = var.writer_endpoint_name
#   type                                      = "CNAME"
#   ttl                                       = var.writer_record_ttl
#   records                                   = [ aws_rds_cluster.cluster.endpoint ]
#   depends_on = [
#     aws_rds_cluster.cluster
#   ]
# }


# resource "aws_route53_record" "reader_endpoint" {
#   zone_id                                   = var.zone_id 
#   name                                      = var.reader_endpoint_name
#   type                                      = "CNAME"
#   ttl                                       = var.reader_record_ttl
#   records                                   = [ aws_rds_cluster.cluster.reader_endpoint ]
#   depends_on = [
#     aws_rds_cluster.cluster
#   ]
# }


resource "aws_rds_cluster" "cluster" {
    allow_major_version_upgrade             = var.allow_major_version_upgrade
    apply_immediately                       = var.apply_immediately
    availability_zones                      = var.availability_zones
    backtrack_window                        = var.backtrack_window
    backup_retention_period                 = var.backup_retention_period
    cluster_identifier                      = var.cluster_identifier != null ? local.cluster_identifier : null
    cluster_identifier_prefix               = var.cluster_identifier_prefix != null ? local.cluster_identifier : null
    copy_tags_to_snapshot                   = var.copy_tags_to_snapshot
    database_name                           = var.database_name
    db_cluster_parameter_group_name         = aws_rds_cluster_parameter_group.cluster.name
    db_subnet_group_name                    = var.db_subnet_group_name
    deletion_protection                     = var.deletion_protection
    enable_http_endpoint                    = var.enable_http_endpoint
    enabled_cloudwatch_logs_exports         = var.enabled_cloudwatch_logs_exports
    engine_mode                             = var.engine_mode
    engine_version                          = var.engine_version
    engine                                  = var.engine
    final_snapshot_identifier               = local.final_snapshot_identifier
    global_cluster_identifier               = var.global_cluster_identifier
    iam_database_authentication_enabled     = var.iam_database_authentication_enabled
    iam_roles                               = var.iam_roles
    kms_key_id                              = var.kms_key_id
    master_password                         = var.master_password
    master_username                         = var.master_username
    port                                    = local.port
    preferred_backup_window                 = var.preferred_backup_window
    preferred_maintenance_window            = var.preferred_maintenance_window
    replication_source_identifier           = var.replication_source_identifier
    skip_final_snapshot                     = var.skip_final_snapshot
    snapshot_identifier                     = var.snapshot_identifier
    source_region                           = var.source_region
    storage_encrypted                       = var.storage_encrypted
    vpc_security_group_ids                  = concat(local.vpc_security_group_ids, aws_security_group.cluster.*.id)
    tags                                    = var.tags 
    
    dynamic "scaling_configuration" {
      for_each = local.scale_config

      content {
          timeout_action            = scaling_configuration.value["timeout_action"]
          auto_pause                = scaling_configuration.value["auto_pause"]
          seconds_until_auto_pause  = scaling_configuration.value["seconds_until_auto_pause"]
          max_capacity              = scaling_configuration.value["max_capacity"]
          min_capacity              = scaling_configuration.value["min_capacity"]
      }
    }

    dynamic "restore_to_point_in_time" {
      for_each = local.pit_config

      content {
          source_cluster_identifier  = restore_to_point_in_time.value["source_cluster_identifier"]
          restore_type               = restore_to_point_in_time.value["restore_type"]
          use_latest_restorable_time = restore_to_point_in_time.value["use_latest_restorable_time"]
          restore_to_time            = restore_to_point_in_time.value["restore_to_time"]
      }
    }
  timeouts {
    create    = var.create_timeout
    update    = var.update_timeout
    delete    = var.delete_timeout
  }
}





