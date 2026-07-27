module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "~> 21.0"

    name = "${var.cluster_name}-cluster"
    kubernetes_version = "1.32.0"

    tags = {
        Environment = var.environment
        terraform = "true"
    }

    vpc_id = var.vpc_id
    subnet_ids = var.subnet_ids

    node_security_group_additional_rules = {

        ingress_cluster_all = {
            description = "Allow all traffic from the cluster"
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    enable_cluster_creator_admin_permissions = true
    authentication_mode = "API_AND_CONFIG_MAP"
    
    endpoint_public_access = true

    addons = {
        vpc_cni = {
        # most_recent = true
          resolve_conflicts = "OVERWRITE"
          before_compute = true
          addon_version  = "v1.19.0-eksbuild.1"
        }
    

        eks-pod-identity-agent = {
          before_compute = true
       }

        coredns = {
          addon_version     = "v1.11.4-eksbuild.2"
          resolve_conflicts = "OVERWRITE"
      }

        kube-proxy = {
          addon_version     = "v1.32.0-eksbuild.2"
          resolve_conflicts = "OVERWRITE"
        }
    }
   eks_managed_node_groups = {
    seshat = {
        ami_type = "AL2023_x86_64_STANDARD"
        instance_types = ["t3.medium"]

        capacity_type = "ON_DEMAND"
        min_size = 1
        max_size = 2
        desired_size = 2

        metadata_options = {
        http_endpoint = "enabled"
        http_tokens = "required"
        http_put_response_hop_limit = 2
    }
        iam_role_additional_policies = {
           AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        }

        labels = {
          role = "general"
        }

        tags = {
          Name = "seshat-node-group"
        }
     }
   }
  }
