class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_recommendation, if: :user_signed_in?
  
  def clear_recommendation_session
    session[:recommendation_id] = nil
    head :ok
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
  
  private
  # popupを表示後、closeされたらリロードしても表示しない。
  # サーバー側のsessionにフラグを立てる。
  def check_recommendation
    return if @recommendation_checked #重複防止
    
    @recommendation_checked = true
    recommendation_service = RecommendationService.new(current_user)
    recommended_order = recommendation_service.generate_recommendation
    
    if recommended_order
      session[:recommendation_id] = recommended_order.id
    end
  end
end

# パターン1: 推奨注文が見つかった場合
#candidate_orders = [Order(id: 5), Order(id: 8)]
#recommended_order = candidate_orders.sample  # Order(id: 8)
#if recommended_order  # true
#  session[:recommendation_id] = 8  # セッションに保存
#end
#
# パターン2: 推奨注文が見つからない場合
#candidate_orders = []  # 空の配列
#recommended_order = candidate_orders.sample  # nil
#if recommended_order  # false
  # この処理は実行されない
#end
# session[:recommendation_id] は nil のまま