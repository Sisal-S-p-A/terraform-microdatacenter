# Terraform global configuration
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 4"
    }
  }
}

locals {
  tenancy = var.tenancy
  name    = var.name

  description = coalesce(var.description, local.name)
  compartment = coalesce(var.target_compartment, local.tenancy)

  defined_tags = merge(
    local.tenancy.defined_tags,
    local.compartment.defined_tags,
    var.defined_tags
  )

  freeform_tags = merge(
    local.tenancy.freeform_tags,
    local.compartment.freeform_tags,
    var.freeform_tags
  )
}

locals {
  group = oci_identity_group.group
}

resource "oci_identity_group" "group" {
  compartment_id = local.tenancy.id

  name        = local.name
  description = local.description

  defined_tags = merge(local.defined_tags, {
  })
  freeform_tags = merge(local.freeform_tags, {
  })
}
