class Menu < ApplicationRecord
  validates :name, presence: true
  validates :store_id, presence: true

  has_many :orders
  has_many :reviews
  has_many :menu_categories
  has_many :categories, through: :menu_categories
  belongs_to :store
end