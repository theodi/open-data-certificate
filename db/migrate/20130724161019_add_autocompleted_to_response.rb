class AddAutocompletedToResponse < ActiveRecord::Migration
  def change
    add_column :responses, :autocompleted, :boolean, :default => false
  end
end
