class Review < ApplicationRecord
  belongs_to :user
  belongs_to :menu

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id menu_id rating updated_at user_id]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
