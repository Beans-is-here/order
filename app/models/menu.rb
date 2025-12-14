class Menu < ApplicationRecord
  before_validation :normalize_name # 正規化

  mount_uploader :image_url, MenuImageUploader
  validates :name, presence: true
  # validates :store_id, presence: true

  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :menu_categories, dependent: :destroy
  has_many :categories, through: :menu_categories
  belongs_to :store

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id name image_url ordered_at share_token updated_at store_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def normalize_name
    Rails.logger.debug { "[DEBUG] normalize_name called with name=#{name}" }
    self.name_normalized = Normalizer.normalize_name(name)
  end
end
