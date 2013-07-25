class AddFullTitleToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :full_title, :string
  end
end
