class AddRequirementToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :requirement, :string
  end
end
