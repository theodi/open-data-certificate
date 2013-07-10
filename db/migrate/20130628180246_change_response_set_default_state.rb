class ChangeResponseSetDefaultState < ActiveRecord::Migration
  def up
    change_column :response_sets, :aasm_state, :string, default: 'draft'

    # update exiting
    ResponseSet.where(aasm_state: 'in_progress').update_all(aasm_state: 'draft')
  end

  def down
    change_column :response_sets, :aasm_state, :string, default: 'in_progress'

    # update exiting
    ResponseSet.where(aasm_state: 'draft').update_all(aasm_state: 'in_progress')
  end
end
