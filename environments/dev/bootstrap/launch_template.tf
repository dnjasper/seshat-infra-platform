locals {
  eks_node_user_data = <<-EOT
    MIME-Version: 1.0
    Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

    --==MYBOUNDARY==
    Content-Type: application/node.eks.aws

    apiVersion: node.eks.aws/v1alpha1
    kind: NodeConfig
    spec:
      cluster:
        name: ${var.cluster_name}

    --==MYBOUNDARY==
    Content-Type: text/x-shellscript; charset="us-ascii"

    #!/bin/bash
    sysctl -w net.ipv4.conf.all.rp_filter=2

    --==MYBOUNDARY==--
  EOT
}

resource "aws_launch_template" "eks_telco_nodes" {
  name_prefix   = "seshat-eks-node-"
  description   = "Launch template for EKS worker nodes with advanced network tuning"
  image_id      = data.aws_ami.eks_worker_ami.id
  instance_type = "t3.medium"


  # Enforce encrypted storage volumes for production compliance
  # block_device_mappings {
  #   device_name = "/dev/xvda"
  #   ebs {
  #     volume_size           = 30
  #     volume_type           = "gp3"
  #     encrypted             = true
  #     delete_on_termination = true
  #   }
  # }



  # Inject the base64-encoded hardware tuning payload
  #user_data = base64encode(local.eks_node_user_data)

  # EKS requires MIME multipart user data when using a custom launch template
  user_data = base64encode(local.eks_node_user_data)

  # Explicitly tag the virtual hardware on creation
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "seshat-cloud-ran-node"
      Environment = "Sandbox"
      ManagedBy   = "Terraform"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


# data "aws_launch_template" "eks_telco_nodes" {

#  filter {
#   name = "launch-template-name"
#   values = ["eks-*"] 
# }
# }

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}