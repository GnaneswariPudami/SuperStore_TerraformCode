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
    actions   = ["ecr:*"]
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

data "aws_ami" "eks_worker_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amazon-eks-node-al2023-x86_64-standard-1.32-v*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["602401143452"] # Amazon EKS AMI Account ID
}

data "cloudinit_config" "eks_node_userdata" {
  gzip          = false
  base64_encode = true

  part {
    content_type = "application/node.eks.aws"
    content = templatefile("${path.module}/template_files/nodeadm.tpl", {
      cluster_name     = aws_eks_cluster.superstore_eks_cluster.name
      cluster_endpoint = aws_eks_cluster.superstore_eks_cluster.endpoint
      cluster_ca       = aws_eks_cluster.superstore_eks_cluster.certificate_authority[0].data
      service_cidr     = aws_eks_cluster.superstore_eks_cluster.kubernetes_network_config[0].service_ipv4_cidr
      environment      = var.environment
    })
  }
}