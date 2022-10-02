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
    managed-by = "Terraform Cloud"
  })
}

locals {
  groups = {
    admins = {
      name        = format("%s-admins", local.compartment.name)
      description = format("Administrators group on %s compartment", local.compartment.name)

      tenancy            = local.tenancy
      target_compartment = local.compartment

      grants = [{
        rights   = "manage",
        resource = "all-resources"
      }]

      freeform_tags = {
        "sisalcloud-rbac-role" = "admin"
      }
    }

    operators = {
      name        = format("%s-operators", local.compartment.name)
      description = format("Operators group on %s compartment", local.compartment.name)

      tenancy            = local.tenancy
      target_compartment = local.compartment

      grants = [{
        rights   = "use",
        resource = "all-resources"
      }]

      freeform_tags = {
        "sisalcloud-rbac-role" = "operator"
      }
    }
  }
}

module "groups" {
  for_each = local.groups

  source = "./modules/group"
  providers = {
    oci = oci
  }

  name        = each.value.name
  description = each.value.description

  tenancy            = each.value.tenancy
  target_compartment = each.value.target_compartment

  grants = each.value.grants

  freeform_tags = each.value.freeform_tags
}

resource "oci_identity_policy" "admin_tenancy" {
  compartment_id = local.tenancy.id

  name        = local.name
  description = format("Grants needed rights to compartment %s administrators at tenency level.", local.compartment.name)

  statements = [
    format("Allow group %s to use users in tenancy",
      module.groups["admins"].group.name
    ),

    format("Allow group %s to manage groups in tenancy where target.group.name='%s'",
      module.groups["admins"].group.name,
      module.groups["operators"].group.name,
    ),
  ]

  defined_tags = merge(local.defined_tags, {
  })
  freeform_tags = merge(local.freeform_tags, {
    sisalcloud-rbac-role = "admin"
  })
}
