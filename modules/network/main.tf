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
    nat      = oci_core_nat_gateway.nat_gateway
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


module "service_gateway" {
  source = "./modules/service_gateway"
  providers = {
    oci = oci
   }
  
  context = merge(local.ctx, { vcn = local.vcn })
}
module "subnet" {
  source = "./modules/subnet"
  providers = {
    oci = oci
  }

  context = merge(local.ctx,
    {
      vcn = merge(
        local.vcn,
        {
          gateway = local.gateway
        }
      )
    }
  )

  name   = "test"
  cidr   = "192.168.0.0/24"
  public = false

}
