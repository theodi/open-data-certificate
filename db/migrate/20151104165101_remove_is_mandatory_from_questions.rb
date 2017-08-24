class RemoveIsMandatoryFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :is_mandatory
  end

  def down
    add_column :questions, :is_mandatory, :boolean
  end
end
