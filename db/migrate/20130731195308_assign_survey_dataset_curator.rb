class AssignSurveyDatasetCurator < ActiveRecord::Migration
  def up
    Survey.update_all({dataset_curator: 'publisher'}, {dataset_curator: nil})
  end

  def down
  end
end
