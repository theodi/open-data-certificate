class CreateEmbedStats < ActiveRecord::Migration
  def change
    create_table(:embed_stats) do |t|
      t.string     :referer
      t.belongs_to :certificate

      t.timestamps
    end

    add_index :embed_stats, :referer, :unique => true
  end
end
