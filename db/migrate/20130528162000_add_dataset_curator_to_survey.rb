class AddDatasetCuratorToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :dataset_curator, :string
  end
end
