output "context" {
  value = merge(local.ctx.vcn.gateway, {
    service = merge(local.gateway, {
      services = merge(local.gateway.services, local.services)
    })
  })
}
