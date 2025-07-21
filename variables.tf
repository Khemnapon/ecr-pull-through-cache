# variables.tf for IAM Module

variable "role_name" {
  description = "IAM role name"
  type        = string
  nullable    = false
}


variable "policy_name" {
  description = "The name of the IAM policy"
  type        = string
}

variable "role_path" {
  description = "Path of IAM role"
  type        = string
  default     = "/"
  nullable    = false
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "credential_arn" {
  description = "ARN of the IAM role or user with permissions to access the upstream registry"
  type        = string
  
}

variable "upstream_registry_url" {
  description = "The URL of the upstream registry"
  type        = string
}

variable "ecr_repository_prefix" {
  description = "Prefix for the ECR repository"
  type        = string
  default     = "docker-hub"
}

variable "prefix" {
  description = "Prefix for the ECR repository"
  type        = string
  default     = "docker-hub"
}

variable "image_tag_mutability" {
  description = "Image tag mutability setting for the ECR repository"
  type        = string
  default     = "MUTABLE"
}

# variable "resource_tags" {
#   description = "A map of tags to assign to the resource"
#   type        = map(string)
# }


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

variable "statements" {
  description = "IAM policy's statements"
  type = list(object({
    sid       = optional(string)
    effect    = optional(string)
    principals = optional(list(object({
      type        = optional(string)
      identifiers = optional(list(string))
    })))
    resources = optional(list(string))
    actions   = optional(string)
    conditions = optional(list(object({
      test     = optional(string)
      values   = list(string)
      variable = optional(string)
    })))
  }))
  nullable = false
  default  = [] # this variable is optional if the policy is overridden by terragrunt
}


variable "service_trusted_role_arns" {
  description = "Services of AWS entities who can assume these roles"
  type        = list(string)
  default     = []
  nullable    = true
}

variable  "registry_resources_policy" {
  description = "List of resources to be created by this module"
  type        = list(string)
  default     = []
  nullable    = true
}

variable "resource_tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
  nullable    = true
}