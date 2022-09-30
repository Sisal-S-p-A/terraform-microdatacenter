variable "tenancy" {
    type = map(any)
    description = "(Required) Tenancy's information [data.oci_identity_tenancy]."
  
}
variable "name" {
  type = string
  description = "(Required) Name"
}

variable "description" {
    type = string
    description = "(Required) Description"
}

variable "tags" {
  type = map(string)
  description = "(Optional) Free forms tags"

  default = {
  }
}