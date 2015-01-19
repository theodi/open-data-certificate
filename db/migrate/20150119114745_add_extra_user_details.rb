class AddExtraUserDetails < ActiveRecord::Migration
  def up
    add_column :users, :organization, :string
    add_column :users, :agreed_to_terms, :boolean, null: false, default: false
  end

  def down
    remove_column :users, :organization
    remove_column :users, :agreed_to_terms
  end
end
