class AddStatusToSurvey < ActiveRecord::Migration
  def up
    add_column :surveys, :status, :string, default: 'alpha'

    Survey.where(title: 'GB').first.update_attribute(:status, 'beta')
  end

  def down
    remove_column :surveys, :status
  end
end
