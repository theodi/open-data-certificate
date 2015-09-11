class RenameSupersededState < ActiveRecord::Migration
  def up
    execute("update response_sets set aasm_state = 'superseded' where aasm_state = 'superceded'")
  end

  def down
  end
end
