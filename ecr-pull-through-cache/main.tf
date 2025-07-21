# main.tf for IAM Module

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecr.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_policy" "this" {
  name   = var.policy_name
  path   = var.role_path
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ecr:CreateRepository",
          "ecr:ReplicateImage",
          "ecr:TagResource"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "kms:CreateGrant",
          "kms:RetireGrant",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}

output "role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.this.arn
}



# Create pull through cache rule
resource "aws_ecr_pull_through_cache_rule" "this" {
  ecr_repository_prefix = var.ecr_repository_prefix
  upstream_registry_url = var.upstream_registry_url
  credential_arn        = var.credential_arn
}
resource "aws_ecr_repository_creation_template" "this" {
  prefix               = var.prefix
  image_tag_mutability = var.image_tag_mutability
  custom_role_arn      = aws_iam_role.this.arn
  repository_policy    = data.aws_iam_policy_document.this.json
  lifecycle {
    create_before_destroy = false
  }

  applied_for = [
    "PULL_THROUGH_CACHE",
  ]

  encryption_configuration {
    encryption_type = "AES256"
  }
  resource_tags = var.resource_tags
  
  depends_on = [
    aws_iam_role.this,
    aws_iam_policy.this,
    aws_iam_role_policy_attachment.this
  ]
}
