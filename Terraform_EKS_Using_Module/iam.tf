# 1. Create OIDC provider for GitHub Actions
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # GitHub OIDC thumbprint
}

# 2. IAM Role for GitHub Actions to Deploy to EKS
resource "aws_iam_role" "eks_github_actions_role" {
  name               = "eks-github-actions-deploy-role"
  assume_role_policy = data.aws_iam_policy_document.github_assume_role_policy.json
}

# 3. Attach permissions to EKS deployment role
resource "aws_iam_role_policy" "eks_github_actions_policy" {
  name   = "eks-github-actions-policy"
  role   = aws_iam_role.eks_github_actions_role.id
  policy = data.aws_iam_policy_document.eks_github_actions_policy.json
}




