data "aws_iam_policy_document" "trust_policy" {
  statement {
    effect  = "Allow"
    actions = var.trusted_role_actions

    principals {
      type        = "AWS"
      identifiers = var.trusted_role_arns
    }
    principals {
      type        = "Service"
      identifiers = var.service_trusted_role_arns
    }
  }
}

resource "aws_iam_policy" "this" {
  name   = "${var.role_name}-policy"
  path   = var.role_path
  policy = data.aws_iam_policy_document.this.json
  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
  name               = var.role_name
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
