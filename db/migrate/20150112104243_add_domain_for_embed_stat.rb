class AddDomainForEmbedStat < ActiveRecord::Migration
  def up
    add_column :embed_stats, :domain, :string
    execute("update embed_stats set domain = substring_index(substring_index(referer, '/', 3), '/', -1)")
    change_column :embed_stats, :domain, :string, null: false
    add_index :embed_stats, :domain, unique: false
  end

  def down
    remove_column :embed_stats, :domain
  end
end
