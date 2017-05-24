FactoryGirl.define do

  sequence(:answer_display_order) { |n| n }

  factory :answer do |a|
    a.association :question # a.question_id               {}
    a.text "My favorite color is clear"
    a.short_text "clear"
    a.help_text "Clear is the absense of color"
                            # a.weight
    a.response_class "string"
                            # a.reference_identifier      {}
                            # a.data_export_identifier    {}
                            # a.common_namespace          {}
                            # a.common_identifier         {}
    a.display_order { FactoryGirl.generate :answer_display_order }
                            # a.is_exclusive              {}
    a.display_type "default"
    # a.display_length            {}
    # a.custom_class              {}
  end

end