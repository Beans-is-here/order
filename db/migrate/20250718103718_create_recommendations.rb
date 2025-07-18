class CreateRecommendations < ActiveRecord::Migration[7.1]
  def change
    create_table :recommendations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.datetime :recommended_at
      t.boolean :acted, default: false #ユーザーがアクションを取ったか　今後の拡張を想定して用意

      t.timestamps
    end
  end
end
