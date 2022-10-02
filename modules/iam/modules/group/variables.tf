variable "tenancy" {
  type = any

  description = "(Required) Tenancy object."
  sensitive   = false
}

variable "name" {
  type = string

  description = "(Required) Group name."
  sensitive   = false
}

variable "grants" {
  type = list(object({
    resource = string
    rights = string
  }))

  default = [ {
    resource = "all-resources"
    rights = "inspect"
  } ]
  
  description = "(Optional) Define rights level (inspect, read, use or manage) for provided resource type (default all-resources)."
  sensitive = false
}

variable "target_compartment" {
    type = any
    default = null

    description = "(Optional) Target Compartment object."
    sensitive = false
}

variable "description" {
  type    = string
  default = ""

  description = "(Optional) Group long description. If empty Name will be used."
  sensitive   = false
}

variable "defined_tags" {
  type    = map(string)
  default = {}

  description = "(Optional) A map of strings to use as defined tags."
  sensitive   = false
}

variable "freeform_tags" {
  type    = map(string)
  default = {}

  description = "(Optional) A map of strings to use as free forms tags."
  sensitive   = false
}
