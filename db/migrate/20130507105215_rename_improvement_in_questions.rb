class RenameImprovementInQuestions < ActiveRecord::Migration
  def change
    rename_column :questions, :improvement, :requirement
  end
end
