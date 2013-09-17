class AddLocaleNameToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :default_locale_name, :string
  end
end
