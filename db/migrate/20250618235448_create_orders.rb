class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :menu, null: false, foreign_key: true
      t.text :memo
      t.datetime :ordered_at
      t.boolean :ordered, null: false, default: true

      t.timestamps
    end
  end
end