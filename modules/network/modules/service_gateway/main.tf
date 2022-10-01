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
  vcn         = local.ctx.vcn
}

locals {
  services = { for service in data.oci_core_services.oci_services.services :
    service.id => service
  }

  gateway = oci_core_service_gateway.service_gateway
}

data "oci_core_services" "oci_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = local.compartment.id
  vcn_id         = local.vcn.id

  display_name = "Oracle Cloud Infrastructure Services network."

  dynamic "services" {
    for_each = local.services

    content {
      service_id = services.key
    }
  }

  freeform_tags = merge({
  }, local.vcn.freeform_tags)
}
