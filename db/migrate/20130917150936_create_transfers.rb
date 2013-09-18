class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.integer :dataset_id
      t.integer :user_id
      t.string :target_email
      t.string :aasm_state, default: 'new'

      t.timestamps
    end
  end
end
