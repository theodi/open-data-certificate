class AddRequirementQuestionsToRequirement < ActiveRecord::Migration
  def change
    add_column :questions, :question_corresponding_to_requirement_id, :string
    add_column :questions, :answer_corresponding_to_requirement_id, :string
    Question.all.map(&:save)
  end
end
