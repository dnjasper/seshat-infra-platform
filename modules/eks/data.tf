data "aws_launch_template" "eks_telco_nodes" {
  name = data.aws_launch_template.eks_telco_nodes.id 
}

data "aws_ami" "eks_worker_ami" {
  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI account ID

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.ami_release_version}-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}