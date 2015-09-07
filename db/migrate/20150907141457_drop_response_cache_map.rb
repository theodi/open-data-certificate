class DropResponseCacheMap < ActiveRecord::Migration
  def up
    drop_table :response_cache_maps
  end

  def down
    create_table "response_cache_maps" do |t|
      t.integer  "origin_id"
      t.integer  "target_id"
      t.integer  "response_set_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.string   "api_id"
    end
  end
end
