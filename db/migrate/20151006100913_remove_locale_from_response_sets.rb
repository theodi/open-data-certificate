class RemoveLocaleFromResponseSets < ActiveRecord::Migration
  def up
    remove_column :response_sets, :locale
  end

  def down
    add_column :response_sets, :locale, :string
  end
end
