output "eks_telco_nodes_launch_template_id" {
  description = "Launch Template ID for EKS nodes"
  value       = aws_launch_template.eks_telco_nodes.id
}