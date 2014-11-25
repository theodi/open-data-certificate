class RemoveAutocompleteOverrideDuplicates < ActiveRecord::Migration
  def up
    find_query = <<-SQL
      select count(id) as count, response_set_id, question_id
      from `autocomplete_override_messages`
      where message is null or trim(message) = ''
      group by response_set_id, question_id
      having count(id) > 1;
    SQL
    select_rows(find_query).each do |count, response_set_id, question_id|
      delete_query = <<-SQL
        delete from autocomplete_override_messages
        where response_set_id = #{response_set_id}
          and question_id = #{question_id}
        limit #{count - 1}
      SQL
      delete(delete_query)
    end
    remove_index :autocomplete_override_messages, name: :i_on_response_set_id_and_question_id
    add_index :autocomplete_override_messages, [:response_set_id, :question_id], unique: true, name: :i_on_response_set_id_and_question_id
  end

  def down
  end
end
