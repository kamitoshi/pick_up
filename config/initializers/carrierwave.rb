require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

unless Rails.env.development? || Rails.env.test?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['S3_ACCESS_KEY'],
      aws_secret_access_key: ENV['S3_SECRET_KEY'],
      region: ENV['S3_REGION']
    }
    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_directory  = 'pickup-images'
    config.asset_host = 'https://s3.amazonaws.com/pickup-images'
    config.fog_public = true
  end
end