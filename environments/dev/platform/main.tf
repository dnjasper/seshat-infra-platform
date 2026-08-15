terraform {
    required_version = "~> 1.6.2"
    required_providers {
       aws = {
         source = "hashicorp/aws"
         version = "~> 6.0"
         }
    }


    backend "s3" {
        bucket = "seshat-infra-tfstate"
        key = "dev/platform/infrastructure.tfstate"
        region = "us-east-1"
        dynamodb_table = "my-ran-infrastructure-locks"
        encrypt = true
    }
}

provider "aws" {
    region = var.region

    default_tags {
      tags = {
        "Automation" = "terraform"
        "Project" = var.project_name
        "Environment" = var.environment
     }
    }

}
provider "kubernetes" {
    host   = module.eks.cluster_endpoint

    cluster_ca_certificate = base64decode(
        module.eks.cluster_certificate_authority_data
    )
 #   token = data.aws_eks_cluster_auth.this.token
    exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", "seshat-cluster",]
    command     = "aws"
  }
}

data "aws_eks_cluster_auth" "this" {
    name = module.eks.cluster_name
}

###############################   VPC  ###############################

# VPC Variables
variable "project_name" { type = string }
variable "region" { type = string }
variable "environment" { type = string }
variable "cluster_name" { type = string }
variable "public_subnet_az1_cidr" { type = string }
variable "public_subnet_az2_cidr" { type = string }
variable "private_subnet_az1_cidr" { type = string }
variable "private_subnet_az2_cidr" { type = string }
variable "private_data_subnet_az1_cidr" { type = string }
variable "private_data_subnet_az2_cidr" { type = string }
variable "vpc_cidr" { type = string }

# VPC

module "vpc" {
    source = "../../../modules/vpc"

    environment                   = var.environment
    project_name                  = var.project_name
    vpc_cidr                      = var.vpc_cidr
    public_subnet_az1_cidr        = var.public_subnet_az1_cidr
    public_subnet_az2_cidr        = var.public_subnet_az2_cidr
    private_subnet_az1_cidr       = var.private_subnet_az1_cidr
    private_subnet_az2_cidr       = var.private_subnet_az2_cidr                                 
}

###############################   EKS  ###############################

# EKS Variables

variable "ec2_instance_type" { type = string }
variable "github_actions_role_arn" { type = string }



module "eks" {
    source = "../../../modules/eks"

    environment  = var.environment
    project_name = var.project_name
    cluster_name = var.cluster_name
    ec2_instance_type = var.ec2_instance_type
   # github_actions_role = var.github_actions_role
   # github_actions_role_arn = aws_iam_role.github_actions_role.arn

    # Outputs
    subnet_ids = module.vpc.private_subnet_ids
    private_subnet_ids = module.vpc.private_subnet_ids
    vpc_id = module.vpc.vpc_id
  # github_actions_role_arn = var.github_actions.github_actions_role_arn
    github_actions_role_arn = "arn:aws:iam::468402787427:role/github_actions_role"
}



# # Github Actions 
# module "github_actions" { 
#     source = "../../../modules/github-actions"
#     github_repository = "dnjasper@26615875/seshat-infra-platform@1308985333:*"
#  }

###############################   IRSA  ###############################
## IRSA Varriables

variable "service_account_name" { type = string }




# IRSA


# OPTIMIZED PARENT LOOP: Replaces both old module blocks completely
module "irsa" {
  source   = "../../../modules/irsa"
   
  environment          = var.environment
  cluster_name         = var.cluster_name
  oidc_provider_arn    = module.eks.oidc_provider_arn
  oidc_provider_url    = module.eks.cluster_oidc_issuer_url
  namespace            = var.namespace
  service_account_name = var.service_account_name
}




###############################  K8s SECRET  ###############################
# Secret Variables

variable "namespace" { type = string }
variable "identity_public_key" { type = string }
variable "identity_private_key" { type = string }
variable "known_hosts" { type = string }

# Secret
module "flux" {
    source = "../../../modules/flux"
   
   # github_token = var.github_token
    identity_public_key = var.identity_public_key
    identity_private_key = var.identity_private_key
    known_hosts = var.known_hosts
    depends_on = [module.eks]

    providers = {
    kubernetes = kubernetes
  }
}

###############################  ECR  ###############################
# ECR Variables

variable "github_token" { type = string }

module "ecr" {
  source = "../../../modules/ecr"

  github_token = var.github_token
  environment = var.environment
 }