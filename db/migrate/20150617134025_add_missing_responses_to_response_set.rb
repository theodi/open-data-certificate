class AddMissingResponsesToResponseSet < ActiveRecord::Migration
  def change
    add_column :response_sets, :missing_responses, :string
  end
end
