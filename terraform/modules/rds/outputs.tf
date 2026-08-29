output "rds_security_group_id" {
  value = aws_security_group.rds.id
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "rds_db_name" {
  description = "The name of the RDS database"
  value       = aws_db_instance.postgres.db_name
}

output "rds_instance_id" {
  description = "The RDS instance identifier"
  value       = aws_db_instance.postgres.identifier
}
