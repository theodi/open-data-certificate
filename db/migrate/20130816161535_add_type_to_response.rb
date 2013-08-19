class AddTypeToResponse < ActiveRecord::Migration
  def change
    add_column :responses, :type, :string
  end
end
