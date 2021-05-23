output "engine_version" {
  value = aws_rds_cluster.cluster.engine_version
}

output "engine" {
  value = aws_rds_cluster.cluster.engine
}

output "cluster_identifier" {
  value = aws_rds_cluster.cluster.cluster_identifier
}

output "preferred_backup_window" {
  value = aws_rds_cluster.cluster.preferred_backup_window
}

output "preferred_maintenance_window" {
  value = aws_rds_cluster.cluster.preferred_maintenance_window
}

output "db_cluster_parameter_group_name" {
  value = aws_rds_cluster.cluster.db_cluster_parameter_group_name
}

output "tags" {
  value = aws_rds_cluster.cluster.tags
}

output "db_subnet_group_name" {
  value = aws_rds_cluster.cluster.db_subnet_group_name
}