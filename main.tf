locals {
  azapi_header = {
    type                 = "Microsoft.Network/privateDnsZones@2024-06-01"
    name                 = var.name
    location             = "global"
    parent_id            = var.resource_group_id
    tags                 = var.tags
    ignore_null_property = true
    retry                = null
  }
  body  = { properties = {} }
  locks = []
  # Post-creation operation for SOA record (separate API call after zone creation)
  post_update0 = var.soa_record != null ? {
    azapi_header = {
      type                 = "Microsoft.Network/privateDnsZones/SOA@2024-06-01"
      name                 = "@"
      parent_id            = null # Will be set by root module to azapi_resource.this.id
      tags                 = null
      ignore_null_property = true
      retry                = null
    }
    body = {
      properties = {
        ttl      = var.soa_record.ttl
        metadata = var.soa_record.tags
        soaRecord = {
          email       = var.soa_record.email
          expireTime  = var.soa_record.expire_time
          minimumTtl  = var.soa_record.minimum_ttl
          refreshTime = var.soa_record.refresh_time
          retryTime   = var.soa_record.retry_time
        }
      }
    }
    locks = local.locks
  } : null
  post_update0_sensitive_body = null
  replace_triggers_external_values = {
    soa_record = { value = var.soa_record }
  }
  sensitive_body = { properties = {} }
  sensitive_body_version = {
    # All possible sensitive field paths with try(tostring(...), "null")
  }
}
