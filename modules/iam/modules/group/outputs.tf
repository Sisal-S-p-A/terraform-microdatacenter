output "group" {
    value = local.group

    description = "An instance of oci_identity_group object."
    sensitive = false
}

output "policy" {
  value = local.policy

  description = "An instance of oci_identity_policy object."
  sensitive = false
}