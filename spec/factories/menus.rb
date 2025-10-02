FactoryBot.define do
  factory :menu do
    name { '美味しいラーメン' }
    association :store
  end
end
