class AddDefaultTitleToDataset < ActiveRecord::Migration
  def up
    change_column :datasets, :title, :string, default: 'Untitiled'
  end

  def down
    change_column :datasets, :title, :string, default: nil
  end
end
