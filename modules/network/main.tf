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
}

resource "oci_core_vcn" "vcn" {
  compartment_id = local.ctx.compartment.id

  cidr_blocks  = ["10.0.0.0/8"]
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

  display_name = data.oci_core_services.oci_services.services[0].description
  services {
    service_id = data.oci_core_services.oci_services.services[0].id
  }

  freeform_tags = merge({
  }, local.vcn.freeform_tags)
}
