terraform {
    required_version = "~> 1.6.2"
    required_providers {
       aws = {
         source = "hashicorp/aws"
         version = "~> 6.0"
         }
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


resource "aws_s3_bucket" "state_bucket" {
  bucket        = "seshat-infra-tfstate"
  force_destroy = false
}


resource "aws_dynamodb_table" "lock_table" {
  name         = "my-ran-infrastructure-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute { 
    name = "LockID"
    type = "S" 
    }
   }
 

# provider "kubernetes" {
#     host   = module.eks.cluster_endpoint

#     cluster_ca_certificate = base64decode(
#         module.eks.cluster_certificate_authority_data
#     )
#     token = data.aws_eks_cluster_auth.this.token
# }

# data "aws_eks_cluster_auth" "this" {
#     name = var.cluster_name
# }



# module "github_actions" { 
#   source = "../../../modules/github-actions"

#   github_repository = "dnjasper@26615875/seshat-infra-platform@1308985333:*"
# }


# 3. REPO 1 PIPELINE ROLE (Using your original module)


resource "aws_iam_openid_connect_provider" "github_actions" {
    url = "https://token.actions.githubusercontent.com"
    client_id_list = ["sts.amazonaws.com"]
    thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]

    lifecycle {
    prevent_destroy = true
  }
}


data "tls_certificate" "github" {
    url = "https://token.actions.githubusercontent.com"

}


module "github_actions_repo1" { 
  source            = "../../../modules/github-actions"
  github_repository = "dnjasper@26615875/seshat-infra-platform@1308985333:*"
}

# 4. REPO 3 PIPELINE ROLE (Using your ECR specific module)
module "github_actions_repo3" {
  source            = "../../../modules/github-actions-ecr"
  github_repository_repo3 = var.github_repository_repo3   
  
}


######################################  VARIABLES  #################################
#variable "cluster_name" { type = string }
variable "project_name" { type = string }
variable "region" { type = string }
variable "environment" { type = string }
variable "github_repository_repo3" { type = string }    