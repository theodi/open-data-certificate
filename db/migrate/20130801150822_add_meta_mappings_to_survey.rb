class AddMetaMappingsToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :meta_map, :string
  end
end
