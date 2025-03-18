resource "aws_ecr_repository" "service-deployment" {
  name                 = var.name
  force_delete         = var.force_delete
  image_tag_mutability = "IMMUTABLE"

  dynamic "encryption_configuration" {
    for_each = local.encryption_configuration
    content {
      encryption_type = encryption_configuration.value["encryption_type"]
      kms_key         = encryption_configuration.value["kms_key"]
    }
  }

  dynamic "image_scanning_configuration" {
    for_each = local.image_scanning_configuration
    content {
      scan_on_push = true
    }
  }

  dynamic "timeouts" {
    for_each = local.timeouts
    content {
      delete = timeouts.value["delete"]
    }
  }

  tags = var.tags
}

# Policy
resource "aws_ecr_repository_policy" "policy" {
  count      = var.policy == null ? 0 : 1
  repository = aws_ecr_repository.service-deployment.name
  #policy     = var.policy
  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "repo policy",
            "Effect": "Allow",
            "Principal": "arn:aws:iam::${var.account_id}:root",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}

# Lifecycle policy
resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  count      = var.lifecycle_policy == null ? 0 : 1
  repository = aws_ecr_repository.service-deployment.name
  #policy     = var.lifecycle_policy
  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire untagged images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Keep last 30 dev images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["dev"],
                "countType": "imageCountMoreThan",
                "countNumber": 30
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

# KMS key
resource "aws_kms_key" "kms_key" {
  count       = local.should_create_kms_key ? 1 : 0
  description = "${var.name} KMS key"
}

resource "aws_kms_alias" "kms_key_alias" {
  count         = local.should_create_kms_key ? 1 : 0
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.kms_key[0].key_id
}

locals {
  should_create_kms_key = var.encryption_type == "KMS" && var.kms_key == null

  # If encryption type is KMS, use assigned KMS key otherwise build a new key
  encryption_configuration = local.should_create_kms_key ? [{
    encryption_type = "KMS"
    kms_key         = aws_kms_key.kms_key[0].arn
    }] : (var.encryption_type == "KMS" ? [{
      encryption_type = "KMS"
      kms_key         = var.kms_key
  }] : [])

  # Image scanning configuration
  # If no image_scanning_configuration block is provided, build one using the default values
  image_scanning_configuration = [{
    scan_on_push = var.image_scanning_configuration != null ? var.image_scanning_configuration.scan_on_push : var.scan_on_push
  }]

  # Timeouts
  # If no timeouts block is provided, build one using the default values
  timeouts = length(var.timeouts) != 0 ? [var.timeouts] : (var.timeouts_delete != null ? [{
    delete = var.timeouts_delete
  }] : [])
}
