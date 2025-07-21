variable "trusted_role_actions" {
  description = "Actions of STS"
  type        = list(string)
  default     = ["sts:AssumeRole"]
  nullable    = false
}

variable "trusted_role_arns" {
  description = "ARNs of AWS entities who can assume these roles"
  type        = list(string)
  default     = []
  nullable    = true
}

variable "service_trusted_role_arns" {
  description = "Services of AWS entities who can assume these roles"
  type        = list(string)
  default     = []
  nullable    = true
}

variable "role_name" {
  description = "IAM role name"
  type        = string
  nullable    = false
}

variable "role_path" {
  description = "Path of IAM role"
  type        = string
  default     = "/"
  nullable    = false
}

variable "statements" {
  description = "IAM policy's statements"
  type = list(object({
    sid       = optional(string)
    effect    = optional(string)
    resources = list(string)
    actions   = list(string)
    conditions = optional(list(object({
      test     = string
      values   = list(string)
      variable = string
    })))
  }))
  nullable = false
  default  = [] # this variable is optional if the policy is overridden by terragrunt
}

variable "json_policy" {
  description = "IAM policy json string"
  type        = string
  default     = "{}"
}

variable "json_policy_template_file" {
  description = "IAM policy json template ex."
  type = object({
    template = string
    values   = optional(map(string))
  })
  default = null
}
