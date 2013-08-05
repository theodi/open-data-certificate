class RemoveColumnsFromDataset < ActiveRecord::Migration
  def up
    remove_column :datasets, :documentation_url
    remove_column :datasets, :curating_org
    remove_column :datasets, :curator_url
    remove_column :datasets, :data_kind
  end

  def down
    add_column :datasets, :data_kind, :string
    add_column :datasets, :curator_url, :string
    add_column :datasets, :curating_org, :string
    add_column :datasets, :documentation_url, :string
  end
end
