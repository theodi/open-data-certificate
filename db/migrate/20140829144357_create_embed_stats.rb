class CreateEmbedStats < ActiveRecord::Migration
  def change
    create_table(:embed_stats) do |t|
      t.string     :referer
      t.belongs_to :dataset

      t.timestamps
    end
  end
end
