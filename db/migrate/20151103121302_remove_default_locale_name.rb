class RemoveDefaultLocaleName < ActiveRecord::Migration
  def up
    remove_column :surveys, :default_locale_name
  end

  def down
    add_column :surveys, :default_locale_name, :string
  end
end
