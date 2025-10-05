class FixStoreUniqueConstraint < ActiveRecord::Migration[7.2]
  def up
    # 既存データで制約違反がないかチェック
    duplicates = Store.group(:name_normalized, :user_id)
                     .having('count(*) > 1')
                     .count
  
    if duplicates.any?
      raise "制約違反データが存在します: #{duplicates}"
    end
  
    remove_index :stores, :name_normalized
    add_index :stores, [:name_normalized, :user_id], unique: true
  end

  def down
    remove_index :stores, [:name_normalized, :user_id]
    add_index :stores, :name_normalized, unique: true
  end
end