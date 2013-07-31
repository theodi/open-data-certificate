class AddDefaultJurisdictionToUser < ActiveRecord::Migration
  def change
    add_column :users, :default_jurisdiction, :string
  end
end
