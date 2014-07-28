class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :survey_translations, :survey_id
    add_index :responses, :response_set_id
    add_index :responses, :question_id
    add_index :responses, :answer_id
    add_index :questions, :question_group_id
    add_index :questions, :correct_answer_id
    add_index :questions, :question_corresponding_to_requirement_id
    add_index :questions, :answer_corresponding_to_requirement_id
    add_index :dependency_conditions, :answer_id
    add_index :dependency_conditions, :question_id
    add_index :transfers, :user_id
    add_index :transfers, :target_user_id
    add_index :transfers, :dataset_id
    add_index :kitten_data, :response_set_id
    add_index :certificates, :response_set_id
    add_index :verifications, [:certificate_id, :user_id]
    add_index :verifications, :user_id
    add_index :verifications, :certificate_id
    add_index :survey_sections, :survey_id
    add_index :response_cache_maps, :response_set_id
    add_index :response_cache_maps, :origin_id
    add_index :response_sets, :survey_id
    add_index :response_sets, :user_id
    add_index :response_sets, :dataset_id
    add_index :datasets, :user_id
    add_index :certificate_generators, :user_id
    add_index :certificate_generators, :response_set_id
    add_index :answers, :question_id
    add_index :answers, :display_order
    add_index :surveys, :access_code
    add_index :surveys, :survey_version
    add_index :autocomplete_override_messages, [:response_set_id, :question_id], name: :i_on_response_set_id_and_question_id
  end
end
