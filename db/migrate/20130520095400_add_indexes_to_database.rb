# encoding: UTF-8
class AddIndexesToDatabase < ActiveRecord::Migration
  def self.up
    add_index :questions, [:survey_section_id, :display_order], name: 'i_questions_on_survey_section_id_and_display_order'
    add_index :questions, [:survey_section_id, :display_type, :requirement, :display_order], name: 'i_questions_on_ss_id_requirement_display_order_and_type'
    add_index :questions, :reference_identifier, name: 'i_questions_on_reference_identifier'
    add_index :answers, :reference_identifier, name: 'i_answers_on_reference_identifier'
    add_index :answers, [:question_id, :display_order], name: 'i_answers_on_question_id_and_display_order'
    add_index :dependencies, :question_id, name: 'i_dependencies_on_question_id'
    add_index :dependency_conditions, :dependency_id, name: 'i_dependency_conditions_on_dependencies_question_id'

  end

  def self.down
    remove_index :questions, name: 'i_questions_on_survey_section_id_and_display_order'
    remove_index :questions, name: 'i_questions_on_ss_id_requirement_display_order_and_type'
    remove_index :questions, name: 'i_questions_on_reference_identifier'
    remove_index :answers, name: 'i_answers_on_reference_identifier'
    remove_index :answers, name: 'i_answers_on_question_id_and_display_order'
    remove_index :dependencies, name: 'i_dependencies_on_question_id'
    remove_index :dependency_conditions, name: 'i_dependency_conditions_on_dependencies_question_id'
  end

end
