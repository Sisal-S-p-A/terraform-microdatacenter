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
  tenancy     = var.tenancy
  name        = var.name
  description = coalesce(var.description, local.name)

  parent = coalesce(var.parent_compartment, local.tenancy)

  freeform_tags = merge(local.parent.freeform_tags, var.freeform_tags)
  defined_tags  = merge(local.parent.defined_tags, var.defined_tags)
}

locals {
  compartment = oci_identity_compartment.compartment
}

resource "oci_identity_compartment" "compartment" {
  compartment_id = local.parent.id

  name        = local.name
  description = local.description

  defined_tags = merge(local.defined_tags, {
  })
  freeform_tags = merge(local.freeform_tags, {
  })
}
