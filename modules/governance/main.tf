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
  description = var.description

  tags = merge({
    terraform-managed-by = "Terraform Cloud"
  }, var.tags)
}

locals {
  compartment = oci_identity_compartment.compartment
  admins      = oci_identity_group.admins
  operators   = oci_identity_group.operators
}

resource "oci_identity_compartment" "compartment" {
  compartment_id = local.tenancy.id

  name          = local.name
  description   = local.description
  enable_delete = true

  freeform_tags = merge({
  }, local.tags)
}

resource "oci_identity_group" "admins" {
  compartment_id = local.tenancy.id
  description    = format("Administrators of compartment %s", local.compartment.name)
  name           = format("%s-admins", local.compartment.name)

  freeform_tags = merge({
    sisalcloud-rbac-role = "admin"
  }, local.tags)
}

resource "oci_identity_group" "operators" {
  compartment_id = local.tenancy.id
  description    = format("Operators of compartment %s", local.compartment.name)
  name           = format("%s-opers", local.compartment.name)

  freeform_tags = merge({
    sisalcloud-rbac-role = "operator"
  }, local.tags)
}

resource "oci_identity_policy" "tenancy" {
  compartment_id = local.tenancy.id

  name = local.compartment.name
  description = format(
    "Manage permissions at Tenancy level for compartment %s.",
    local.compartment.name
  )

  statements = [
    format("Allow group %s to use users in tenancy",
      local.admins.name
    ),

    format("Allow group %s to manage policies in tenancy where target.compartment.name='%s'",
      local.admins.name,
      local.compartment.name
    ),
    /* 
        format("Allow group %s to manage groups in tenancy where target.group.name='%s'",
            local.admins.name,
            local.admins.name
        ),
 */
    format("Allow group %s to manage groups in tenancy where target.group.name='%s'",
      local.admins.name,
      local.operators.name
    ),
  ]

  freeform_tags = merge({
    sisalcloud-compartment-ref = local.compartment.id
  }, local.tags)
}

resource "oci_identity_policy" "admin" {
  compartment_id = local.compartment.id

  name = format("%s", local.admins.name)
  description = format(
    "Manage permissions at compartment level for group %s.",
    local.admins.name
  )

  statements = [
    format("Allow group %s to manage all-resources in compartment %s",
        local.admins.name,
        local.compartment.name
    )
  ]

  freeform_tags = merge({
    sisalcloud-group-ref = local.admins.id
  }, local.tags)
}

resource "oci_identity_policy" "operator" {
  compartment_id = local.compartment.id

  name = format("%s", local.operators.name)
  description = format(
    "Manage permissions at compartment level for group %s.",
    local.operators.name
  )

  statements = [
    format("Allow group %s to use all-resources in compartment %s",
        local.operators.name,
        local.compartment.name
    )
  ]

  freeform_tags = merge({
    sisalcloud-group-ref = local.operators.id
  }, local.tags)
}