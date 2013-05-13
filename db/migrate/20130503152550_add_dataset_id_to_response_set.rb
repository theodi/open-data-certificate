class AddDatasetIdToResponseSet < ActiveRecord::Migration
  def change
    add_column :response_sets, :dataset_id, :integer
  end
end
