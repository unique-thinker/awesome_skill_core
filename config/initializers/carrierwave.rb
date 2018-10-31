# frozen_string_literal: true

CarrierWave.configure do |config|
  config.enable_processing = true

  if Rails.env.production?
    config.fog_provider = 'fog/aws'
    require 'carrierwave/storage/fog'
    config.storage = :fog
    config.cache_dir = Rails.root.join('tmp', 'uploads').to_s
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     '',
      aws_secret_access_key: '',
      region:                ''
    }
  elsif Rails.env.development?
    config.storage = :file
    config.root = Rails.root.join('storage', 'development').to_s
  elsif Rails.env.test?
    config.storage = :file
    config.root = Rails.root.join('storage', 'test').to_s
  else
    config.storage = :file
  end
end
