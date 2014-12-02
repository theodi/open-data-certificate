class RestoreDocumentationUrls < ActiveRecord::Migration
  def up
    update(<<-SQL)
      update datasets d
      join response_sets rs on (rs.dataset_id = d.id and rs.aasm_state = 'published')
      right outer join responses r on (rs.id=r.response_set_id)
      join questions q on (r.question_id = q.id and q.`reference_identifier` = 'documentationUrl')
      set d.documentation_url = r.string_value
      where documentation_url not like 'http%' and r.string_value like 'http%';
    SQL
  end

  def down
  end
end
