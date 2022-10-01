output "service_gateway" {
  value = local.service_gateway
}

output "context" {
  value = merge(local.ctx, {
    vcn = merge(local.vcn, {
      gateway = merge(local.vcn.gateway, {
        service = local.service_gateway
      })
    })
  })
}
