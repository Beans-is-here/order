class Order < ApplicationRecord
  validates :user_id, presence: true
  validates :menu_id, presence: true
  validates :memo, length: { maximum: 40 }

  belongs_to :user
  belongs_to :menu
  has_many :recommendations

  scope :latest, -> {order(Arel.sql("ordered_at IS NULL DESC, ordered_at DESC"))}
  scope :old, -> {order(Arel.sql("ordered_at IS NULL DESC, ordered_at ASC"))}
end
