FactoryBot.define do
  factory :store do
    sequence(:name) { |n| "店舗#{n}" }
    association :user
  end
end