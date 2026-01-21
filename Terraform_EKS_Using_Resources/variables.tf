variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "environment" {
  description = "The deployment environment"
  type        = string
}

variable "openid_audience" {
  type        = string
  default     = "sts.amazonaws.com"
  description = "The OIDC audience for GitHub Actions"
}
variable "github_repository" {
  type = object({
    full_name = string
  })

  description = "The GitHub repository details where the OIDC provider will be used for authentication"
}

variable "sns_email_endpoint" {
  description = "The email endpoint for SNS topic subscriptions"
  type        = string
}

variable "vpc_id" {
  description = "VPC Id"
  type        = string
}

variable "ecr_services_repositories" {
  description = "List of services names to ECR repository names"
  type        = list(string)
}
