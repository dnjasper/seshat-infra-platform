variable "cluster_name" {
    description = "The name of the EKS cluster"
    type        = string
}

variable "environment" {
   description = "The environment for the EKS cluster"
   type = string
}

variable "vpc_id" {
    description = "The ID of the VPC where the EKS cluster will be deployed"
    type        = string
}

variable "subnet_ids" {
    description = "The IDs of the subnets where the EKS cluster will be deployed"
    type = list(string)
}

variable "ec2_instance_type" {
    description = "The EC2 instance type for the EKS worker nodes"
    type        = string
}
variable "project_name" {
    description = "The name of the project for the EKS cluster"
    type        = string
}

variable "private_subnet_ids" {
  type = list(string)
  description = "List of private subnet IDs for the EKS cluster"
}

variable "github_actions_role_arn" {
  type = string
  description = "The ARN of the GitHub Actions IAM role for EKS access"
}