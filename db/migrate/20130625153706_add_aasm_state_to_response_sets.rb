class AddAasmStateToResponseSets < ActiveRecord::Migration
  def change
    add_column :response_sets, :aasm_state, :string, default: 'in_progress'
  end
end
