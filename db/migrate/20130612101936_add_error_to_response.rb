class AddErrorToResponse < ActiveRecord::Migration
  def change
    add_column :responses, :error, :boolean, :default => false
  end
end
