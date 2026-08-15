region                  = "us-east-1"
environment             = "dev"
project_name            = "seshat-infra"
cluster_name            = "seshat"
vpc_cidr                = "10.0.0.0/16"
public_subnet_az1_cidr  = "10.0.0.0/24"
public_subnet_az2_cidr  = "10.0.1.0/24"
private_subnet_az1_cidr = "10.0.2.0/24"
private_subnet_az2_cidr = "10.0.3.0/24"

private_data_subnet_az1_cidr = "10.0.4.0/24"
private_data_subnet_az2_cidr = "10.0.5.0/24"

# love

ec2_instance_type = "t3.medium"


# Github-Actions

github_actions_role_arn = "arn:aws:iam::468402787427:role/github_actions_role"


# Secret Variables

namespace            = "kube-system"
# identity_public_key  = ""
# identity_private_key = ""
# known_hosts          = ""

# IRSA Variables

service_account_name = "aws-load-balancer-controller"
#oidc_provider_arn = "arn:aws:iam::468402787427:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/1C4FB856A634DF213AA574863810B236"
#oidc_provider_url = "https://oidc.eks.us-east-1.amazonaws.com/id/1C4FB856A634DF213AA574863810B236"