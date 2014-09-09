class AddEmbedStatReferenceToCertificate < ActiveRecord::Migration
  def change
    add_column :certificates, :embed_stat_id, :integer
  end
end
