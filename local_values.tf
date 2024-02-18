locals {
  owners      = var.owners
  environment = var.environment
  category    = var.category
  name        = "${var.owners}-${var.environment}"
  common_tags = {
    owners   = local.owners
    category = local.category
  }
  eks_cluster_name = var.cluster_name
} 