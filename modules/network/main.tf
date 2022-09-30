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
  ctx = var.context
}

resource "oci_core_vcn" "vcn" {
  compartment_id = local.ctx.compartment.id

  cidr_blocks  = ["10.0.0.0/8"]
  display_name = local.ctx.compartment.name

  freeform_tags = merge({
  }, local.ctx.compartment.freeform_tags)
}
