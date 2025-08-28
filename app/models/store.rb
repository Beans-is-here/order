class Store < ApplicationRecord
  before_validation :normalize_name #正規化
  
  validates :name, presence: true
  belongs_to :user
  has_many :menus
  has_many :recommendations

  private

   def normalize_name
     puts "[DEBUG] normalize_name called with name=#{self.name}"
     self.name_normalized = Normalizer.normalize_name(name)
   end
end
