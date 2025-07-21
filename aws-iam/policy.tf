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
      sid       = try(statement.value.sid, null) # Use null if sid is not provided
      effect    = coalesce(statement.value.effect, "Allow")
      resources = statement.value.resources
      actions   = statement.value.actions
      dynamic "condition" {
        for_each = coalesce(statement.value.conditions, [])
        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}
