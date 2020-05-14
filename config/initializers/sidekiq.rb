require 'sidekiq'
require 'sidekiq-status'

REDIS_CONFIG = {
  host: ENV['REDIS_HOST'],
  port: ENV['REDIS_PORT'] || '6379'
}

REDIS_CONFIG.merge!({password: ENV['REDIS_PASSWORD']}) unless ENV['REDIS_PASSWORD'].blank?

Sidekiq.configure_server do |config|
  config.redis = REDIS_CONFIG
end

Sidekiq.configure_client do |config|
  config.redis = REDIS_CONFIG
  Sidekiq::Status.configure_server_middleware config, expiration: 30.minutes
  Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes
end