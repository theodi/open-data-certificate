FactoryGirl.define do

  sequence(:question_display_order) { |n| n }

  factory :question do |q|
    q.association :survey_section # s.survey_section_id       {}
                                  # q.question_group_id       {}
    q.text "What is your favorite color?"
    q.short_text "favorite_color"
    q.help_text "just write it in the box"
    q.pick :none
    q.reference_identifier { |me| "q_#{me.object_id}" }
                                  # q.data_export_identifier  {}
                                  # q.common_namespace        {}
                                  # q.common_identifier       {}
    q.display_order FactoryGirl.generate :question_display_order
                                  # q.display_type            {} # nil is default
                                  # q.display_width           {}
    q.correct_answer_id nil

    q.text_as_statement "Favourite Color"

    factory :question_on_certificate do |qc|
      qc.display_on_certificate true
    end

    factory :requirement do
      reference_identifier 'level_1'
      display_type 'label'
      is_requirement true
    end
  end

  factory :question_group do |g|
    g.text { "Describe your family" }
    g.help_text {}
    g.reference_identifier { |me| "g_#{me.object_id}" }
    g.data_export_identifier {}
    g.common_namespace {}
    g.common_identifier {}
    g.display_type {}
    g.custom_class {}
  end

end
