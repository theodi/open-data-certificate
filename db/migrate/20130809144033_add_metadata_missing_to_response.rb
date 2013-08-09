class AddMetadataMissingToResponse < ActiveRecord::Migration
  def change
    add_column :responses, :metadata_missing, :boolean, default: false
  end
end
