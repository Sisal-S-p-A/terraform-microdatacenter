variable "context" {
  type = any
  description = "(Required) Infrastructure context."
}

variable "name" {
  type = string
  description = "(Required) Name of subent."
}

variable "cidr" {
  type = string
  description = "(Required) CIDR of subnet."
}

variable "public" {
  type = bool
  default = false

  description = "(Optional) Subnet can have public ip address"
}