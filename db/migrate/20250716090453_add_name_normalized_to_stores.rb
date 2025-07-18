class AddNameNormalizedToStores < ActiveRecord::Migration[7.1]
  def change
    add_column :stores, :name_normalized, :string
  end
end
