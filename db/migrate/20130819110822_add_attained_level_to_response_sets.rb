class AddAttainedLevelToResponseSets < ActiveRecord::Migration
  def change
    add_column :response_sets, :attained_index, :integer
  end
end
