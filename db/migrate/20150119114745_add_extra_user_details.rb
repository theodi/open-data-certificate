class AddExtraUserDetails < ActiveRecord::Migration
  def up
    add_column :users, :organization, :string
    add_column :users, :agreed_to_terms, :boolean, null: true, default: nil
  end

  def down
    remove_column :users, :organization
    remove_column :users, :agreed_to_terms
  end
end
