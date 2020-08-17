output "host_name" {
  value = azurerm_redis_cache.redis.hostname
}

output "access_key" {
  value = azurerm_redis_cache.redis.primary_access_key
}

output "redis_port" {
  value = azurerm_redis_cache.redis.ssl_port
}

