class CreateClaims < ActiveRecord::Migration
  def change
    create_table :claims do |t|
      t.belongs_to :dataset, :null => false
      t.belongs_to :initiating_user, :null => false
      t.belongs_to :user, :null => false
      t.string :aasm_state, :null => false

      t.timestamps
    end
  end
end
