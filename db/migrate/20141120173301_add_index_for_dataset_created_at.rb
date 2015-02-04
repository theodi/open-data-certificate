class AddIndexForDatasetCreatedAt < ActiveRecord::Migration
  def up
    remove_index :datasets, :user_id
    add_index :datasets, [:user_id, :created_at]
  end

  def down
    remove_index :datasets, [:user_id, :created_at]
    add_index :datasets, :user_id
  end
end
