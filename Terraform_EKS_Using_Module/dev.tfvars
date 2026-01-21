aws_region                = "eu-west-2"
environment               = "dev"
sns_email_endpoint        = "gnaneswari.pudami@gmail.com"
ecr_services_repositories = ["superstore-config-server", "superstore-notifications-service"]
github_repository = {
  full_name = "GnaneswariPudami/SuperStore_Microservices"
}
vpc_id                 = "vpc-064bff9e96f9a1f78"
eks_cluster_name       = "superstore-eks-cluster-dev"
eks_kubernetes_version = "1.33"