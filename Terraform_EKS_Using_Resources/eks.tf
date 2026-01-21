resource "aws_eks_cluster" "superstore_eks_cluster" {
  name = "superstore-eks-cluster"

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.eks_cluster_iam_role.arn
  version  = "1.32"

  bootstrap_self_managed_addons = false

  compute_config {
    enabled       = true
    node_pools    = ["general-purpose"]
    node_role_arn = aws_iam_role.eks_node_iam_role.arn
  }

  kubernetes_network_config {
    elastic_load_balancing {
      enabled = true
    }
  }

  storage_config {
    block_storage {
      enabled = true
    }
  }

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true

    subnet_ids = data.aws_subnets.subnets.ids
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSComputePolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSBlockStoragePolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSLoadBalancingPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSNetworkingPolicy,
  ]
}

# Creating Node Group for EKS Cluster
resource "aws_eks_node_group" "superstore_eks_cluster_node_group" {
  cluster_name    = aws_eks_cluster.superstore_eks_cluster.name
  node_group_name = "general-purpose"
  node_role_arn   = aws_iam_role.eks_node_iam_role.arn
  subnet_ids      = data.aws_subnets.subnets.ids

  launch_template {
    id      = aws_launch_template.eks_node_launch_template.id
    version = aws_launch_template.eks_node_launch_template.latest_version
  }

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  tags = {
    Environment = var.environment
    Name        = "superstore-eks-node-group"
  }

  depends_on = [
    aws_eks_cluster.superstore_eks_cluster
  ]
}
