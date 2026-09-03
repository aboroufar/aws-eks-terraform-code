# Dedicated Secret in AWS Secrets Manager for ArgoCD cluster credentials
resource "aws_secretsmanager_secret" "argocd_cluster_credentials" {
  name                    = "argocd/clusters/${module.eks.cluster_name}"
  description             = "EKS cluster credentials for ArgoCD registration"
  recovery_window_in_days = 0 # Forces immediate deletion upon destroy

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

# IAM Policy permitting CodeBuild to write credentials to this secret
resource "aws_iam_policy" "codebuild_secrets_manager_write" {
  name        = "${module.eks.cluster_name}-codebuild-sm-write"
  description = "Allows CodeBuild to write EKS registration payload to Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "WriteClusterSecret"
        Effect = "Allow"
        Action = [
          "secretsmanager:PutSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret.argocd_cluster_credentials.arn
      }
    ]
  })
}

# Attach policy to your CodeBuild Execution Role
resource "aws_iam_role_policy_attachment" "codebuild_sm_write_attach" {
  role       = "eks-codebuild-service-role" # Replace with your CodeBuild execution role name
  policy_arn = aws_iam_policy.codebuild_secrets_manager_write.arn
}

# Output the Secret ARN / ID so buildspecs can reference it dynamically
output "argocd_secret_id" {
  description = "Secrets Manager Secret ID for ArgoCD cluster credentials"
  value       = aws_secretsmanager_secret.argocd_cluster_credentials.name
}