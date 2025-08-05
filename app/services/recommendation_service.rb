class RecommendationService
  def initialize(user)
    @user = user
  end

  def generate_recommendation
    # 対象となる注文（ordered = false）を取得
    candidate_orders = @user.orders.where(ordered: false)
    
    # 最近3日間にリコメンドされたものを除外（一時的にコメントアウト）
    # recent_recommended_order_ids = @user.recommendations
    #   .where('recommended_at > ?', 3.days.ago)
    #   .pluck(:order_id)
    
    # available_orders = candidate_orders.where.not(id: recent_recommended_order_ids)
    # available_orders.sample
    
    # テスト用に簡単な実装
    candidate_orders.sample
    # 配列からランダムに抽出
  end
end