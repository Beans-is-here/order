FactoryBot.define do
  factory :user do
    name { "田中太郎" }
    sequence(:email) { |n| "order_#{n}@example.com" }
    sequence(:password) { |n| "Password#{n}" }
    sequence(:password_confirmation) { |n| "Password#{n}" }
  end
end
