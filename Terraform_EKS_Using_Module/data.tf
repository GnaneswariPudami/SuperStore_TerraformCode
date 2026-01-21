data "aws_iam_policy_document" "github_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      variable = "token.actions.githubusercontent.com:aud"
      test     = "StringEquals"
      values   = [var.openid_audience]
    }

    condition {
      variable = "token.actions.githubusercontent.com:sub"
      test     = "StringLike"
      values   = ["repo:${var.github_repository.full_name}:*"]
    }
  }
}

data "aws_iam_policy_document" "eks_github_actions_policy" {
  statement {
    effect    = "Allow"
    actions   = ["ecr:*", "eks:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecs_github_actions_policy" {
  statement {
    effect    = "Allow"
    actions   = ["ecr:*", "ecs:*"]
    resources = ["*"]
  }
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

