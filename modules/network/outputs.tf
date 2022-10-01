output "context" {
  description = "Provides new infrastructure context enriched with networks elements."

  value = merge(
    local.ctx,
    {
      vcn = merge(
        local.vcn,
        {
          gateway = local.gateway
        }
      )
    }
  ) 

  sensitive = false
}