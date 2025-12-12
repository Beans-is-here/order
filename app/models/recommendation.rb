class Recommendation < ApplicationRecord
  belongs_to :user
  belongs_to :order
  belongs_to :store

  def self.ransackable_attributes(_auth_object = nil)
    %w[acted created_at id order_id recommended_at updated_at user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
