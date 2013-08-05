class AddDocumentationUrlBackToDataset < ActiveRecord::Migration
  def change
    add_column :datasets, :documentation_url, :string
  end
end
