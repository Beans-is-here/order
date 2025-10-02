class OrderSharesController < ApplicationController
  #  skip_before_action :require_login, only: [:show]

  def show
    @order = Order.find_by(share_token: params[:token])
    return redirect_to root_path unless @order

    # OGP用のメタ情報
    @share_title = build_share_title
    @share_description = build_share_description
    @share_image = build_share_image
    @share_url = request.original_url

    # デバッグ用ログ
    Rails.logger.info '=== OGP Debug ==='
    Rails.logger.info "Title: #{@share_title}"
    Rails.logger.info "Description: #{@share_description}"
    Rails.logger.info "Image: #{@share_image}"
    Rails.logger.info "URL: #{@share_url}"
  end

  private

  def build_share_title
    'Order?'
  end

  def build_share_description
    '"前にもこれ食べたな" 注文時の悩みを記録で解決'
  end

  def build_share_image
    ActionController::Base.helpers.asset_url('icon.png')
  end
end
