locals {
  services = ["cart-service", "order-service", "product-service", "user-service", "frontend"]
}

resource "aws_ecr_repository" "repos" {
  for_each = toset(local.services)
  name     = "ecom-${each.key}"
  image_tag_mutability = "MUTABLE"
  lifecycle {
    prevent_destroy = false
  }
}

output "ecr_repositories" {
  value = { for k, r in aws_ecr_repository.repos : k => r.repository_url }
}
