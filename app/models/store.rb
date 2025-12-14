class Store < ApplicationRecord
  before_validation :normalize_name # 正規化

  validates :name, presence: true
  belongs_to :user
  has_many :menus, dependent: :destroy
  has_many :recommendations, dependent: :destroy

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id name ordered ordered_at share_token updated_at user_id]
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
