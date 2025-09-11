FactoryBot.define do
  factory :order do
    ordered { false }
    association :user
    association :menu
    ordered_at { Time.current }

    trait :ordered do
      ordered { true }
    end

    trait :wanted do
      ordered { false }
    end
  end
end
