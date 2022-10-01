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
  vcn = oci_core_vcn.vcn
  gateway = {
    internet = oci_core_internet_gateway.internet_gateway
    nat = oci_core_nat_gateway.nat_gateway
    service = oci_core_service_gateway.service_gateway
  }
}

resource "oci_core_vcn" "vcn" {
  compartment_id = local.ctx.compartment.id

  cidr_blocks  = ["192.168.0.0/16"]
  display_name = local.ctx.compartment.name

  freeform_tags = merge({
  }, local.ctx.compartment.freeform_tags)
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = local.vcn.compartment_id
  vcn_id         = local.vcn.id

  display_name = "Internet Gateway"
  freeform_tags = merge({
  }, local.vcn.freeform_tags)
}

resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = local.vcn.compartment_id
  vcn_id         = local.vcn.id

  display_name = "NAT Gateway"
  freeform_tags = merge({
  }, local.vcn.freeform_tags)
}

data "oci_core_services" "oci_services" {}
resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = local.vcn.compartment_id
  vcn_id         = local.vcn.id

  display_name = "Oracle Cloud Infrastructure Services network."

  dynamic "services" {
    for_each = { for service in data.oci_core_services.oci_services.services:
      service.id => service
    }

    content {
      service_id = services.key
    }
  }

  freeform_tags = merge({
  }, local.vcn.freeform_tags)
}
