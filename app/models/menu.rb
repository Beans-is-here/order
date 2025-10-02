class Menu < ApplicationRecord
  before_validation :normalize_name # 正規化

  mount_uploader :image_url, MenuImageUploader
  validates :name, presence: true
  # validates :store_id, presence: true

  has_many :orders
  has_many :reviews
  has_many :menu_categories
  has_many :categories, through: :menu_categories
  belongs_to :store

  private

  def normalize_name
    Rails.logger.debug { "[DEBUG] normalize_name called with name=#{name}" }
    self.name_normalized = Normalizer.normalize_name(name)
  end
end
