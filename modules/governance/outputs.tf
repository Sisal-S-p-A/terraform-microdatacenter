output "context" {
  value = merge(var.context, {
    compartment = local.compartment
    groups = {
      admins    = local.admins
      operators = local.operators
      instances = local.instances
    }
    policies = {
      global    = oci_identity_policy.tenancy
      admins    = oci_identity_policy.admin
      operators = oci_identity_policy.operator
      instances = oci_identity_policy.instance
    }
  })
}
