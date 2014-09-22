class AddEmbedStatReferenceToDataset < ActiveRecord::Migration
  def change
    add_column :datasets, :embed_stat_id, :integer
  end
end
