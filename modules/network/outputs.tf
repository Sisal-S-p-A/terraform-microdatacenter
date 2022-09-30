output "context" {
  value = merge(local.ctx, {
    vcn = local.vcn
    gateway = local.gateway
  })
}