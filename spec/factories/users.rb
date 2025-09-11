FactoryBot.define do
  factory :user do
    name { "田中太郎" }
    sequence(:email) { |n| "order_#{n}@example.com" }
    password { "Password123" }
    password_confirmation { password }
  end
end
