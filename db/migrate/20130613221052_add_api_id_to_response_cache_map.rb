class AddApiIdToResponseCacheMap < ActiveRecord::Migration
  def change
    add_column :response_cache_maps, :api_id, :string
  end
end
