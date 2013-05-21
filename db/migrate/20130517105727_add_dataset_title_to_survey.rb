class AddDatasetTitleToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :dataset_title, :string
  end
end
