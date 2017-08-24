class ImproveQuestionRequirementColumns < ActiveRecord::Migration
  def up
    add_column :questions, :is_requirement, :boolean, default: false, after: :api_id
    add_column :questions, :corresponding_requirements, :string, after: :is_requirement

    Question.where(display_type: 'label').where('requirement is not null').update_all(is_requirement: true)
    Question.where('display_type != "label" AND requirement is not null').update_all('corresponding_requirements=requirement')

    remove_column :questions, :requirement
  end

  def down
    add_column :questions, :requirement, :string, after: :api_id

    Question.where('corresponding_requirements is not null').update_all('requirement=corresponding_requirements')
    Question.where(is_requirement: true).update_all('requirement=reference_identifier')

    remove_column :questions, :corresponding_requirements
    remove_column :questions, :is_requirement
  end
end
