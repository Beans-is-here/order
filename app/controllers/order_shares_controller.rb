class OrderSharesController < ApplicationController
# skip_before_action :require_login, only: [:show]

  def show
    @order = Order.find_by(share_token: params[:token])
#    return redirect_to root_path unless @order

    # OGP用のメタ情報
    @share_title = build_share_title
    @share_description = build_share_description
    # @share_image = asset_url('sample.png')
    @share_url = request.original_url

    # post本文
    @share_data = {
      store_name: @order&.menu&.store&.name,
      menu_name: @order&.menu&.name
      #ordered: @order&.ordered || false
    }
  end

  # デバッグ用ログ
    Rails.logger.info "=== OGP Debug ==="
    Rails.logger.info "Title: #{@share_title}"
    Rails.logger.info "Description: #{@share_description}"
    Rails.logger.info "URL: #{@share_url}"

  private
  def build_share_title
    "注文履歴アプリOrder?"
  end

  def build_share_description
    "前にもこれ食べた? 注文時の悩みを記録で解決"
  end
end