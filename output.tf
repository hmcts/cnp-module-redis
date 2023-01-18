output "host_name" {
  value       = azurerm_redis_cache.redis.hostname
  description = "Host name of the Redis cache"
}

output "access_key" {
  value       = azurerm_redis_cache.redis.primary_access_key
  description = "Primary access key to connect to redis with"
}

output "redis_port" {
  value       = azurerm_redis_cache.redis.ssl_port
  description = "SSL port to connect to redis with"
}
