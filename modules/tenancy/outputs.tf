output "tenancy" {
  value = merge(local.tenancy, {
    regions = merge({home = local.home_region}, {target = local.target_region})
  })

  description = "Enriched data.oci_identity_tenancy object with regions details."
  sensitive = false
}