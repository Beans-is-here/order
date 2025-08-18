class AddShareTokenToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :share_token, :string
    add_index :orders, :share_token, unique: true
  end
end
