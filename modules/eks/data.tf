# data "aws_launch_template" "eks_telco_nodes" {
 
#  filter {
#   name = "launch-template-name"
#   values = ["eks-*"] 
# }
# }
data "aws_ami" "eks_worker_ami" {
  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI account ID

#   filter {
#     name   = "name"
#     values = ["amazon-eks-node-${var.ami_release_version}-*"]
#   }

# filter {
#     name   = "name"
#     # This explicit string guarantees an absolute match against Amazon's pattern
#     values = ["amazon-eks-node-${trimspace(var.ami_release_version)}-v*"]
# }
  filter {
    name   = "name"
    # Aligns perfectly with AWS's updated Amazon Linux 2023 name layout
    values = ["amazon-eks-node-al2023-x86_64-standard-1.30-v*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}