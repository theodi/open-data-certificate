class MoveAutocompleteOverrideMessageToResponse < ActiveRecord::Migration
  def up
    add_column :responses, :explanation, :string, :default => nil
    update_query = <<-SQL
      update responses r
      join autocomplete_override_messages ac
      on (r.response_set_id = ac.response_set_id and r.question_id = ac.question_id)
      set r.explanation = ac.message
      where ac.message is not null and trim(ac.message) != ''
    SQL
    update(update_query)
    drop_table :autocomplete_override_messages
  end

  def down
    create_table :autocomplete_override_messages do |t|
      t.belongs_to :response_set
      t.belongs_to :question
      t.text :message
      t.timestamps
    end
    insert_query = <<-SQL
      insert into autocomplete_override_messages (response_set_id, question_id, message, updated_at, created_at)
      select response_set_id, question_id, explanation as message, updated_at, created_at from responses;
    SQL
    update(insert_query)
    remove_column :responses, :explanation
  end
end
