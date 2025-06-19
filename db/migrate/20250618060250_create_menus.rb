class CreateMenus < ActiveRecord::Migration[7.1]
  def change
    create_table :menus do |t|
      t.string :name, null: false
      t.references :store, null: false, foreign_key: true
      t.string :image_url
      t.timestamps
    end
  end
end