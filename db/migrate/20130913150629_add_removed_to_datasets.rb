class AddRemovedToDatasets < ActiveRecord::Migration
  def change
    add_column :datasets, :removed, :boolean, default: false
  end
end
