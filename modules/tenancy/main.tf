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
  tenancy = data.oci_identity_tenancy.tenancy
  regions = data.oci_identity_region_subscriptions.regions.region_subscriptions

  home_region = { for region in local.regions :
    region.region_key => region if region.is_home_region
  }

  target_region = { for region in local.regions :
    region.region_key => region if region.region_name == var.target_region
  }
}


data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.oci_tenancy_id
}

data "oci_identity_region_subscriptions" "regions" {
  tenancy_id = local.tenancy.id
}
