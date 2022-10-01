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
  name = var.name
  cidr = var.cidr
  public = var.public
}

locals {
  ctx = var.context
  compartment = local.ctx.compartment
  vcn = local.ctx.vcn
  gateway = local.vcn.gateway
}

locals {
  route_table = oci_core_route_table.route_table
}

resource "oci_core_route_table" "route_table" {
    compartment_id = local.compartment.id
    vcn_id = local.vcn.id

    display_name = local.name

    route_rules {
        description = "Default route"

        destination_type = "CIDR_BLOCK"
        destination = "0.0.0.0/0"

        network_entity_id = local.public ? local.gateway.internet.id : local.gateway.nat
    }

    dynamic "route_rules" {
        for_each = local.public ? local.gateway.service : {}
        content {
            description = route_rules.value.service_name

            destination_type = "SERVICE_CIDR_BLOCK"
            destination = route_rules.value.cidr_block

            network_entity_id = local.gateway.service.id
        }
    }

    freeform_tags = merge({
    }, local.vcn.freeform_tags)
}