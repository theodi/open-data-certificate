class AddTargetUserToTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :target_user_id, :integer
  end
end
