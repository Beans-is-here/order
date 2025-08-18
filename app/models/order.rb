class Order < ApplicationRecord
  before_create :generate_share_token
  
  validates :user_id, presence: true
  validates :menu_id, presence: true
  validates :memo, length: { maximum: 40 }

  belongs_to :user
  belongs_to :menu
  has_many :recommendations

  scope :latest, -> {order(Arel.sql("ordered_at IS NULL DESC, ordered_at DESC"))}
  scope :old, -> {order(Arel.sql("ordered_at IS NULL DESC, ordered_at ASC"))}

  # orderedフラグで未注文も選択可能にする。
  def share_title
    if ordered?
      "#{menu.store.name}で#{menu.name}を注文しました。"
    else
      "#{menu.store.name}で#{menu.name}を気になったメニュに追加しました。"
    end
  end

  def share_description
    desc_parts = []
    desc_parts << "#{menu.store.name}の#{menu.name}"

    review = menu.reviews.find_by(user: user)
    if review.present?
      desc_parts << "評価: #{'★' * review.rating}"
    end

    if memo.present?
      desc_parts << ""#{memo}""
    end

    desc_parts.join(' | ')
  end

  def order_share_url
    Rails.application.routes.url_helpers.order_share_url(share_token)
  end

    # 🆕 レビュー取得用のヘルパーメソッド
  #def user_review_for_menu
  #  menu.reviews.find_by(user: user)
  #end
  

  private
  
  def generate_share_token
    self.share_token ||= SecureRandom.urlsafe_base64(32)
  end
end
