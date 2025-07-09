require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
    config.storage :fog
    config.fog_provider = 'fog/aws'
    config.fog_directory  = ENV['AWS_BUCKET_NAME']
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: 'ap-northeast-1', # リージョン
      path_style: true
    }
puts "AWS_ACCESS_KEY_ID: #{ENV['AWS_ACCESS_KEY_ID'].present? ? '設定済み' : '未設定'}"
puts "AWS_SECRET_ACCESS_KEY: #{ENV['AWS_SECRET_ACCESS_KEY'].present? ? '設定済み' : '未設定'}"

end 