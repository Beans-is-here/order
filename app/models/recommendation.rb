class Recommendation < ApplicationRecord
  belongs_to :user
  belongs_to :order
  belongs_to :store
end
