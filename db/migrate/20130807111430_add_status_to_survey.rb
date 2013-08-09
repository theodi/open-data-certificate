class AddStatusToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :status, :string, default: 'alpha'
  end
end
