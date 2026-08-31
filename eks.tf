module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # Cluster endpoint access
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # Enable OIDC provider for IAM Roles for Service Accounts (IRSA)
  enable_irsa = true

  # Grants the creator admin access to the cluster (EKS Access Entries API)
  enable_cluster_creator_admin_permissions = true

  # Managed Node Group using Spot instances for cost efficiency
  eks_managed_node_groups = {
    spot_workers = {
      name          = "spot-eks-workers"
      instance_types = ["t3.medium", "t3a.medium"]
      capacity_type  = "SPOT"

      min_size     = 1
      max_size     = 1
      desired_size = 1

      disk_size = 20

      labels = {
        Environment = "test"
        Lifecycle   = "spot"
      }
    }
  }

  tags = {
    Environment = "gitops-lab"
    ManagedBy   = "terraform"
  }
}