class AddNameNormalizedToMenus < ActiveRecord::Migration[7.1]
  def change
    add_column :menus, :name_normalized, :string
  end
end
