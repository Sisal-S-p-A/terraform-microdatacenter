output "compartment" {
  value = merge(local.compartment,
    {
      groups = {
        admins    = local.admins,
        operators = local.operators
      }
    }
  )
}
