# ──────────────────────────────────────────────
# VPC Outputs
# ──────────────────────────────────────────────
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_ip" {
  description = "The Elastic IP address of the NAT Gateway"
  value       = module.vpc.nat_gateway_ip
}

# ──────────────────────────────────────────────
# EKS Outputs
# ──────────────────────────────────────────────
output "eks_cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "The Kubernetes server version of the EKS cluster"
  value       = module.eks.cluster_version
}

output "eks_cluster_oidc_issuer" {
  description = "The OIDC issuer URL for the EKS cluster"
  value       = module.eks.cluster_oidc_issuer
}

output "eks_cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "eks_node_group_name" {
  description = "Name of the EKS node group"
  value       = module.eks.node_group_name
}

output "eks_node_group_status" {
  description = "Status of the EKS node group"
  value       = module.eks.node_group_status
}

output "eks_node_security_group_id" {
  description = "Security group ID attached to EKS worker nodes"
  value       = module.eks.node_security_group_id
}

# ──────────────────────────────────────────────
# RDS Outputs
# ──────────────────────────────────────────────
output "rds_endpoint" {
  description = "Endpoint for PostgreSQL RDS"
  value       = module.rds.rds_endpoint
}

output "rds_db_name" {
  description = "The name of the RDS database"
  value       = module.rds.rds_db_name
}

output "rds_instance_id" {
  description = "The RDS instance identifier"
  value       = module.rds.rds_instance_id
}

output "rds_security_group_id" {
  description = "Security group ID attached to the RDS instance"
  value       = module.rds.rds_security_group_id
}

# ──────────────────────────────────────────────
# ECR Outputs
# ──────────────────────────────────────────────
output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "ecr_repository_id" {
  description = "The ID of the ECR repository"
  value       = module.ecr.repository_id
}
