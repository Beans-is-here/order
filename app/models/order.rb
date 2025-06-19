class Order < ApplicationRecord
  validates :user_id, presence: true
  validates :menu_id, presence: true
  validates :memo, length: { maximum: 40 }

  belongs_to :user
  belongs_to :menu
end
