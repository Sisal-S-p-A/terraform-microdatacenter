variable "tenancy" {
  type = any

  description = "(Required) Tenancy object."
  sensitive   = false
}

variable "name" {
  type = string

  description = "(Required) Compartment name."
  sensitive = false
}

variable "description" {
  type = string

  description = "(Optional) Compartment long description. If empty Name will be used."
  default = ""
  sensitive = false
}

variable "parent_compartment" {
  type = any

  description = "(Optional) data.oci_identity_compartment. If null Tenancy will be used."
  default     = null
  sensitive   = false
}

variable "defined_tags" {
    type = map(string)

    description = "(Optional) A map of strings to use as defined tags."
    default = {}
    sensitive = false
}

variable "freeform_tags" {
    type = map(string)

    description = "(Optional) A map of strings to use as free form tags."
    default = {}
    sensitive = false
}
