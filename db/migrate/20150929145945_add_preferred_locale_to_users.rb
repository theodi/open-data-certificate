class AddPreferredLocaleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :preferred_locale, :string, default: 'en'
  end
end
