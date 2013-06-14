class CreateResponseCacheMaps < ActiveRecord::Migration
  def change
    create_table :response_cache_maps do |t|
      t.integer :origin_id
      t.integer :target_id
      t.integer :response_set_id

      t.timestamps
    end
  end
end
