class AddIndexToStoresNameNormalized < ActiveRecord::Migration[7.1]
  def change
    add_index :stores, :name_normalized, unique: true
  end
end
