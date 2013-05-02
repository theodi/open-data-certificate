class AddImprovementToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :improvement, :string
  end
end
