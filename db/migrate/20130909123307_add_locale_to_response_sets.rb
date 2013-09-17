class AddLocaleToResponseSets < ActiveRecord::Migration
  def change
    add_column :response_sets, :locale, :string
  end
end
