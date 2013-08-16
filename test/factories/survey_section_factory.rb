FactoryGirl.define do
  
  sequence(:survey_section_display_order) { |n| n }

  factory :survey_section do |s|
    s.association :survey # s.survey_id                 {}
    s.title { "Demographics" }
    s.description { "Asking you about your personal data" }
    s.display_order { FactoryGirl.generate :survey_section_display_order }
    s.reference_identifier { "demographics" }
    s.data_export_identifier { "demographics" }
  end

end