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
  ctx         = var.context
  compartment = local.ctx.compartment
}

locals {
  vcn             = oci_core_vcn.vcn
  service_gateway = module.service_gateway.gateway
}

resource "oci_core_vcn" "vcn" {
  compartment_id = local.compartment.id

  display_name = local.compartment.name
  cidr_blocks = [
    "192.168.0.0/16"
  ]

  freeform_tags = merge(local.compartment.freeform_tags, {
  })
}

module "service_gateway" {
  source = "./modules/service_gateway"
  providers = {
    oci = oci
  }

  context = merge(local.ctx, { vcn = local.vcn })
}
