class RemoveOrphanedDraftCertificates < ActiveRecord::Migration
  def up
    delete(<<-SQL)
      delete c
      from certificates c
      left outer join response_sets rs on (c.response_set_id = rs.id)
      where rs.id is null
    SQL
  end

  def down
  end
end
