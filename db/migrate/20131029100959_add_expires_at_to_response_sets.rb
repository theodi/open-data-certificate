class AddExpiresAtToResponseSets < ActiveRecord::Migration
  def change
    add_column :response_sets, :expires_at, :datetime
  end
end
