class CreateAutocompleteOverrideMessages < ActiveRecord::Migration
  def change
    create_table :autocomplete_override_messages do |t|
      t.integer :response_set_id
      t.integer :question_id
      t.text :message

      t.timestamps
    end
  end
end
