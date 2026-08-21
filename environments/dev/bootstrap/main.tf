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
        key = "dev/bootstrap/infrastructure.tfstate"
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
    token = data.aws_eks_cluster_auth.this.token
}

data "aws_eks_cluster_auth" "this" {
    name = var.cluster_name
}



module "github_actions" { 
  source = "../../../modules/github-actions"

  github_repository = "dnjasper@26615875/seshat-infra-platform@1308985333:*"
}


######################################  VARIABLES  #################################
variable "cluster_name" { type = string }
variable "project_name" { type = string }
variable "region" { type = string }
variable "environment" { type = string }