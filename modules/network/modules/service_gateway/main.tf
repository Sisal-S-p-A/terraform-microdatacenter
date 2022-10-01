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
  oci_services = { for service in data.oci_core_services.oci_services.services :
    service.id => service
  }

  # oci_core_service_gateway.service_gateway with services attribute enriched by data.oci_core_services.oci_services.services
  service_gateway = merge(oci_core_service_gateway.service_gateway, {
    services = merge(oci_core_service_gateway.service_gateway.services, local.oci_services)
  })
}

data "oci_core_services" "oci_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = local.vcn.compartment_id
  vcn_id         = local.vcn.id

  display_name = "Oracle Cloud Infrastructure service network."

  dynamic "services" {
    for_each = local.oci_services
    content {
      service_id = services.value.id
    }
  }

  freeform_tags = merge(local.vcn.freeform_tags, {
  })
}
