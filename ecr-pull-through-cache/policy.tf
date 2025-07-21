# allow to override this resource
# if it is too complicate to declare either json string or variables
locals {
  json_policy_template = var.json_policy_template_file != null ? templatefile(var.json_policy_template_file.template, coalesce(var.json_policy_template_file.values, {})) : "{}"
}

data "aws_iam_policy_document" "this" {
  source_policy_documents = [
    local.json_policy_template,
    var.json_policy,
  ]
  dynamic "statement" {
    for_each = var.statements
    content {
      sid    = "PullImage"
      effect = "Allow"
      # resources = try(statement.value.resources, null)
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
      actions = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:DescribeImageScanFindings",
          "ecr:DescribeImages",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr:ListImages"
        ]
      
      dynamic "condition" {
        for_each = coalesce(statement.value.conditions, [])
        content {
          test     = "ForAnyValue:ArnEquals"
          values   = condition.value.values
          variable = "aws:PrincipalArn"
        }
      }
    }
  }
}
