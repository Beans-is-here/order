FactoryBot.define do
  factory :order_form_attributes, class: Hash do
    store_name { '店舗テスト' }
    menu_name { 'メニューテスト' }
    memo { 'メモテスト' }
    ordered { true }

    # バリデーション
    trait :invalid_store_name do
      store_name { '' }
    end

    trait :invalid_menu_name do
      menu_name { '' }
    end

    trait :long_memo do
      memo { 'a' * 41 }
    end

    trait :with_review do
      review_rating { 2 }
    end

    trait :not_ordered do
      ordered { false }
    end

    # ファクトリの結果をHashとして返す。
    initialize_with { attributes.stringify_keys }
  end
end
