class AddTokenToTransfer < ActiveRecord::Migration
  def change
    add_column :transfers, :token, :string
  end
end
