resource "aws_ecr_repository" "superstore_app_repo" {
  for_each             = toset(var.ecr_services_repositories)
  name                 = each.value
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = each.value
    Environment = var.environment
  }
}