class RenameAnswersRequirement < ActiveRecord::Migration
  def up
    rename_column :answers, :requirement, :corresponding_requirements
  end

  def down
    rename_column :answers, :corresponding_requirements, :requirement
  end
end
