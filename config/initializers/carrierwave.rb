# frozen_string_literal: true

CarrierWave.configure do |config|
  if !Rails.env.test? && ENV['S3_BUCKET_ENABLE'] == 'true'
    config.fog_provider = "fog/aws"
    require "carrierwave/storage/fog"
    config.storage = :fog
    config.cache_dir = Rails.root.join('tmp', 'uploads').to_s
    config.fog_credentials = {
        provider:              'AWS',
        aws_access_key_id:     '',
        aws_secret_access_key: '',
        region:                ''
    }
  elsif Rails.env.test?
    CarrierWave.configure do |config|
      config.storage = :file
      config.enable_processing = false
    end
  else
    config.storage = :file
  end
end

if defined?(CarrierWave)
  CarrierWave::Uploader::Base.descendants.each do |klass|
    next if klass.anonymous?
    klass.class_eval do
      def cache_dir
        "#{Rails.root}/tmp/spec/uploads/tmp"
      end 
               
      def store_dir
        "#{Rails.root}/tmp/spec/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end 
    end 
  end 
end
