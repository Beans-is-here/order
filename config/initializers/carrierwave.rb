CarrierWave.configure do |config|
    if Rails.env.production?
      # 本番環境でのみS3設定を読み込む
      if ENV['AWS_ACCESS_KEY_ID'].present? && ENV['AWS_SECRET_ACCESS_KEY'].present?
        # 既存の設定
      else
        # 環境変数が読み込めない場合の処理
        Rails.logger.error "AWS credentials not found"
      end
    end
  end