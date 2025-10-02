require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  # config.storage :fog
  config.fog_provider = 'fog/aws'
  config.fog_directory = ENV.fetch('AWS_BUCKET_NAME', nil)
  config.fog_public = false # trueにするとURLから誰でも見られる。
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID', nil),
    aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY', nil),
    region: ENV.fetch('AWS_REGION', nil) # リージョン
    # path_style: true
  }
end
