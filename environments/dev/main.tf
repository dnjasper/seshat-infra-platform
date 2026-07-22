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
        key = "dev/infrastructure.tfstate"
        region = var.region
        dynamodb_endpoint = "my-ran-infrastructure-locks"
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
    token = data.aws_eks_cluster_data.this.token
}

data "aws_eks_cluster_data" "this" {
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
    source = "../../modules/vpc"

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
variable "subnet_ids" { type = string }

module "eks" {
    source = "../../modules/eks"

    environment  = var.environment
    project_name = var.project_name
    cluster_name = var.cluster_name
    ec2_instance_type = var.ec2_instance_type

    # Outputs
    subnet_ids = module.vpc.private_subnet_ids
    private_subnet_ids = module.vpc.private_subnet_ids
    vpc_id = module.vpc.vpc_id
}

###############################   IRSA  ###############################
## IRSA Varriables

variable "oidc_provider_arn" { type = string }
variable "service_account_name" { type = string }


# IRSA

module "irsa" {
    source = "../../module/irsa"
    environment = var.environment
    cluster_name = var.cluster_name
    oidc_provider_arn = module.eks.oidc_provider_arn
    namespace           = kube-system
    service_account_name = var.service_account_name
}

module "flux_irsa" {
    source = "../../module/irsa"
    environment = var.environment
    cluster_name = var.cluster_name
    oidc_provider_arn = module.eks.oidc_provider_arn
    namespace           = flux-system
    service_account_name = var.service_account_name
}

###############################  K8s SECRET  ###############################
# Secret Variables

variable "namespace" { type = string }
variable "identity_public_key" { type = string }
variable "identity_private_key" { type = string }
variable "known_hosts" { type = string }

# Secret
module "k8s-secret" {
    source = "../../module/k8s-secret"

    identity_public_key = var.identity_public_key
    identity_private_key = var.identity_private_key
    known_hosts = var.known_hosts
    depends_on = [module.eks]
}

###############################  ECR  ###############################
# ECR Variables

