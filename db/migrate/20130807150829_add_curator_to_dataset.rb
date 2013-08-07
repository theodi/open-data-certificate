class AddCuratorToDataset < ActiveRecord::Migration
  def change
    add_column :datasets, :curator, :string
  end
end
