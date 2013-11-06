# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131031142907) do

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.text     "text"
    t.text     "short_text"
    t.text     "help_text"
    t.integer  "weight"
    t.string   "response_class"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.boolean  "is_exclusive"
    t.integer  "display_length"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "default_value"
    t.string   "api_id"
    t.string   "display_type"
    t.string   "input_mask"
    t.string   "input_mask_placeholder"
    t.string   "requirement"
    t.string   "help_text_more_url"
    t.string   "input_type"
    t.string   "placeholder"
    t.string   "text_as_statement"
  end

  add_index "answers", ["api_id"], :name => "uq_answers_api_id", :unique => true
  add_index "answers", ["question_id", "display_order"], :name => "i_answers_on_question_id_and_display_order"
  add_index "answers", ["reference_identifier"], :name => "i_answers_on_reference_identifier"

  create_table "autocomplete_override_messages", :force => true do |t|
    t.integer  "response_set_id"
    t.integer  "question_id"
    t.text     "message"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "certificates", :force => true do |t|
    t.integer  "response_set_id"
    t.text     "name"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "attained_level"
    t.string   "curator"
    t.boolean  "published",       :default => false
    t.datetime "expires_at"
  end

  create_table "datasets", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "documentation_url"
    t.string   "curator"
    t.boolean  "removed",           :default => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "dependencies", :force => true do |t|
    t.integer  "question_id"
    t.integer  "question_group_id"
    t.string   "rule"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "dependencies", ["question_id"], :name => "i_dependencies_on_question_id"

  create_table "dependency_conditions", :force => true do |t|
    t.integer  "dependency_id"
    t.string   "rule_key"
    t.integer  "question_id"
    t.string   "operator"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "dependency_conditions", ["dependency_id"], :name => "i_dependency_conditions_on_dependencies_question_id"

  create_table "dev_events", :force => true do |t|
    t.text     "message",    :limit => 65535
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "kitten_data", :force => true do |t|
    t.text     "data"
    t.integer  "response_set_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "url"
  end

  create_table "question_groups", :force => true do |t|
    t.text     "text"
    t.text     "help_text"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.string   "display_type"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "api_id"
  end

  add_index "question_groups", ["api_id"], :name => "uq_question_groups_api_id", :unique => true

  create_table "questions", :force => true do |t|
    t.integer  "survey_section_id"
    t.integer  "question_group_id"
    t.text     "text"
    t.text     "short_text"
    t.text     "help_text"
    t.string   "pick"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.string   "display_type"
    t.boolean  "is_mandatory"
    t.integer  "display_width"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.integer  "correct_answer_id"
    t.string   "api_id"
    t.string   "requirement"
    t.string   "required",                                 :default => "",    :null => false
    t.string   "help_text_more_url"
    t.string   "text_as_statement"
    t.boolean  "display_on_certificate",                   :default => false
    t.string   "question_corresponding_to_requirement_id"
    t.string   "answer_corresponding_to_requirement_id"
  end

  add_index "questions", ["api_id"], :name => "uq_questions_api_id", :unique => true
  add_index "questions", ["reference_identifier"], :name => "i_questions_on_reference_identifier"
  add_index "questions", ["survey_section_id", "display_order"], :name => "i_questions_on_survey_section_id_and_display_order"
  add_index "questions", ["survey_section_id", "display_type", "requirement", "display_order"], :name => "i_questions_on_ss_id_requirement_display_order_and_type"

  create_table "response_cache_maps", :force => true do |t|
    t.integer  "origin_id"
    t.integer  "target_id"
    t.integer  "response_set_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "api_id"
  end

  create_table "response_sets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "survey_id"
    t.string   "access_code"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "api_id"
    t.integer  "dataset_id"
    t.string   "aasm_state",     :default => "draft"
    t.integer  "attained_index"
    t.string   "locale"
  end

  add_index "response_sets", ["access_code"], :name => "response_sets_ac_idx", :unique => true
  add_index "response_sets", ["api_id"], :name => "uq_response_sets_api_id", :unique => true

  create_table "responses", :force => true do |t|
    t.integer  "response_set_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.string   "response_group"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "survey_section_id"
    t.string   "api_id"
    t.boolean  "error",             :default => false
    t.boolean  "autocompleted",     :default => false
  end

  add_index "responses", ["api_id"], :name => "uq_responses_api_id", :unique => true
  add_index "responses", ["survey_section_id"], :name => "index_responses_on_survey_section_id"

  create_table "survey_parsings", :force => true do |t|
    t.string   "file_name"
    t.string   "md5"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "survey_parsings", ["file_name"], :name => "index_survey_parsings_on_file_name"

  create_table "survey_sections", :force => true do |t|
    t.integer  "survey_id"
    t.string   "title"
    t.text     "description"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.string   "custom_class"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.boolean  "display_header",         :default => true
  end

  create_table "survey_translations", :force => true do |t|
    t.integer  "survey_id"
    t.string   "locale"
    t.text     "translation", :limit => 16777215
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "surveys", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "access_code"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.datetime "active_at"
    t.datetime "inactive_at"
    t.string   "css_url"
    t.string   "custom_class"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "display_order"
    t.string   "api_id"
    t.integer  "survey_version",         :default => 0
    t.string   "dataset_title"
    t.string   "dataset_curator"
    t.string   "full_title"
    t.string   "meta_map"
    t.string   "status",                 :default => "alpha"
    t.string   "default_locale_name"
  end

  add_index "surveys", ["access_code", "survey_version"], :name => "surveys_access_code_version_idx", :unique => true
  add_index "surveys", ["api_id"], :name => "uq_surveys_api_id", :unique => true

  create_table "transfers", :force => true do |t|
    t.integer  "dataset_id"
    t.integer  "user_id"
    t.string   "target_email"
    t.string   "aasm_state",     :default => "new"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "token"
    t.integer  "target_user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "default_jurisdiction"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "validation_conditions", :force => true do |t|
    t.integer  "validation_id"
    t.string   "rule_key"
    t.string   "operator"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.string   "regexp"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "validations", :force => true do |t|
    t.integer  "answer_id"
    t.string   "rule"
    t.string   "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "verifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "certificate_id"
    t.integer  "value"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

end
