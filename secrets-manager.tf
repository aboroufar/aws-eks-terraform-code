# Dedicated Secret in AWS Secrets Manager for ArgoCD cluster credentials
resource "aws_secretsmanager_secret" "argocd_cluster_credentials" {
  name                    = "argocd/clusters/${module.eks.cluster_name}"
  description             = "EKS cluster credentials for ArgoCD registration"
  recovery_window_in_days = 0

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

output "argocd_secret_id" {
  description = "Secrets Manager Secret ID for ArgoCD cluster credentials"
  value       = aws_secretsmanager_secret.argocd_cluster_credentials.name
}

# REMOVE or DELETE these blocks below:
# resource "aws_iam_policy" "codebuild_secrets_manager_write" { ... }
# resource "aws_iam_role_policy_attachment" "codebuild_sm_write_attach" { ... }