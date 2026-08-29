output "node_security_group_id" {
  description = "Security group ID of the EKS nodes"
  value       = aws_security_group.eks_nodes.id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = aws_eks_cluster.main.name
}
